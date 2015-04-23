require 'spec_helper'

describe WPScan::Finders::PluginVersion::SitepressMultilingualCms::VersionParameter do
  subject(:finder) { described_class.new(plugin) }
  let(:plugin)     { WPScan::Plugin.new('sitepress-multilingual-cms', target) }
  let(:target)     { WPScan::Target.new('http://wp.lab/') }
  let(:fixtures)   { File.join(FINDERS_FIXTURES, 'plugin_version', 'sitepress_multilingual_cms', 'version_parameter') }

  before { expect(target).to receive(:content_dir).and_return('wp-content') }

  describe '#passive' do
    after do
      stub_request(:get, target.url).to_return(body: File.read(File.join(fixtures, file)))

      result = finder.passive

      expect(result).to eql @expected
      expect(result.interesting_entries).to eql @expected.interesting_entries if @expected
    end

    context 'when no version' do
      let(:file) { 'no_version.html' }

      it 'returns nil' do
        @expected = nil
      end
    end

    context 'when it matches' do
      let(:file) { '3.1.8.4.html' }

      it 'returns it' do
        @expected = WPScan::Version.new(
          '3.1.8.4',
          found_by: 'Version Parameter (Passive Detection)',
          confidence: 50,
          interesting_entries: %w(http://wp.lab/wp-content/plugins/sitepress-multilingual-cms/res/js/jquery.cookie.js?v=3.1.8.4)
        )
      end
    end
  end
end
