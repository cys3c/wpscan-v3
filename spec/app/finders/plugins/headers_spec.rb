require 'spec_helper'

describe WPScan::Finders::Plugins::Headers do
  subject(:finder) { described_class.new(target) }
  let(:target)     { WPScan::Target.new(url) }
  let(:url)        { 'http://wp.lab/' }

  def plugin(name)
    WPScan::Plugin.new(name, target, found_by: 'Headers (Passive Detection)', confidence: 60)
  end

  describe '#passive' do
    after do
      stub_request(:get, target.url).to_return(headers: headers)
      expect(finder.passive).to eq @expected
    end

    context 'when empty headers' do
      let(:headers) { nil }

      it 'returns an empty array' do
        @expected = []
      end
    end

    context 'when headers' do
      before { expect(target).to receive(:content_dir).and_return('wp-content') }

      let(:headers) { {} }
      let(:w3_total_cache) { plugin('w3-total-cache') }
      let(:wp_super_cache) { plugin('wp-super-cache') }

      context 'when w3-total-cache and wp_super_cache detected' do
        it 'returns the array with the w3_total_cache' do
          headers['X-Powered-BY'] = 'W3 Total Cache/0.9'
          headers['WP-Super-Cache'] = 'Served supercache file from PHP'

          @expected = [w3_total_cache, wp_super_cache]
        end
      end

      context 'when a header key with multiple values' do
        let(:headers) { { 'X-Powered-BY' => ['PHP/5.4.9', 'ASP.NET'] } }

        it 'returns the array with the w3_total_cache' do
          headers['X-Powered-BY'] << 'W3 Total Cache/0.9.2.5'

          @expected = [w3_total_cache]
        end
      end
    end
  end
end
