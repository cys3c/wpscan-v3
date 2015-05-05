require 'spec_helper'

describe WPScan::Finders::PluginVersion::Revslider::ReleaseLog do
  subject(:finder) { described_class.new(plugin) }
  let(:plugin)     { WPScan::Plugin.new('revslider', target) }
  let(:target)     { WPScan::Target.new('http://wp.lab/') }
  let(:fixtures)   { File.join(FINDERS_FIXTURES, 'plugin_version', 'revslider', 'release_log') }

  before { expect(target).to receive(:content_dir).and_return('wp-content') }

  describe '#aggressive' do
    after do
      stub_request(:get, finder.release_log_url).to_return(body: File.read(File.join(fixtures, file)))

      result = finder.aggressive

      expect(result).to eql @expected
      expect(result.interesting_entries).to eql @expected.interesting_entries if @expected
    end

    context 'when no version/matches' do
      let(:file) { 'no_version.html' }

      it 'returns nil' do
        @expected = nil
      end
    end

    context 'when the version matches' do
      let(:file) { '4.6.5.html' }

      it 'returns it' do
        @expected = WPScan::Version.new(
          '4.6.5',
          found_by: 'Release Log (Aggressive Detection)',
          confidence: 90,
          interesting_entries: ["#{finder.release_log_url}, Version 4.6.5 SkyWood (02nd December 2014)"]
        )
      end
    end
  end
end
