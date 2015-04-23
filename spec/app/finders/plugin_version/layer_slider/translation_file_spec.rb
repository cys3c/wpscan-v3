require 'spec_helper'

describe WPScan::Finders::PluginVersion::LayerSlider::TranslationFile do
  subject(:finder) { described_class.new(plugin) }
  let(:plugin)     { WPScan::Plugin.new('LayerSlider', target) }
  let(:target)     { WPScan::Target.new('http://wp.lab/') }
  let(:fixtures)   { File.join(FINDERS_FIXTURES, 'plugin_version', 'layer_slider', 'translation_file') }

  before { expect(target).to receive(:content_dir).and_return('wp-content') }

  describe '#aggressive' do
    after do
      stub_request(:get, /.*/)
      stub_request(:get, stubbed_url).to_return(body: File.read(File.join(fixtures, file)))

      result = finder.aggressive

      expect(result).to eql @expected
      expect(result.interesting_entries).to eql @expected.interesting_entries if @expected
    end

    let(:stubbed_url) { finder.potential_urls.sample }

    context 'when no matches' do
      let(:file) { 'no_matches.po' }

      it 'returns nil' do
        @expected = nil
      end
    end

    context 'when no version' do
      let(:file) { 'no_version.po' }

      it 'returns nil' do
        @expected = nil
      end
    end

    context 'when the version matches' do
      context 'when <= 4.x' do
        let(:file) { '4.5.5.po' }

        it 'returns it' do
          @expected = WPScan::Version.new(
            '4.5.5',
            found_by: 'Translation File (Aggressive Detection)',
            confidence: 90,
            interesting_entries: ["#{stubbed_url}, Project-Id-Version: LayerSlider WP v4.5.5"]
          )
        end
      end

      context 'when 5.x' do
        let(:file) { '5.2.0.po' }

        it 'returns it' do
          @expected = WPScan::Version.new(
            '5.2.0',
            found_by: 'Translation File (Aggressive Detection)',
            confidence: 90,
            interesting_entries: ["#{stubbed_url}, Project-Id-Version: LayerSlider WP 5.2.0"]
          )
        end
      end
    end
  end
end
