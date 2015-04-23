require 'spec_helper'

describe WPScan::Finders::PluginVersion::SitepressMultilingualCms::MetaGenerator do
  subject(:finder) { described_class.new(plugin) }
  let(:plugin)     { WPScan::Plugin.new('sitepress-multilingual-cms', target) }
  let(:target)     { WPScan::Target.new('http://wp.lab/') }
  let(:fixtures)   { File.join(FINDERS_FIXTURES, 'plugin_version', 'sitepress_multilingual_cms', 'meta_generator') }

  describe '#passive' do
    before { stub_request(:get, target.url).to_return(body: body) }

    context 'when not found' do
      let(:body) { '' }

      its(:passive) { should be_nil }
    end

    context 'when found' do
      after do
        version = finder.passive

        expect(version).to eql @expected
        expect(version.interesting_entries).to eql @expected.interesting_entries if @expected
      end

      context 'when no version' do
        let(:body) { File.read(File.join(fixtures, 'no_version.html')) }

        it 'returns nil' do
          @expected = nil
        end
      end

      context 'when version' do
        let(:body) { File.read(File.join(fixtures, '3.1.8.4.html')) }

        it 'returns the expected version' do
          @expected = WPScan::Version.new(
            '3.1.8.4',
            confidence: 50,
            found_by: 'Meta Generator (Passive detection)',
            interesting_entries: [
              "http://wp.lab/, <meta name=\"generator\" content=\"WPML ver:3.1.8.4 stt:1,63;0\">"
            ]
          )
        end
      end
    end
  end
end
