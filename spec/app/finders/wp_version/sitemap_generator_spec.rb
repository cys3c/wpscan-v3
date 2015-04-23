require 'spec_helper'

describe WPScan::Finders::WpVersion::SitemapGenerator do
  subject(:finder)  { described_class.new(target) }
  let(:target)      { WPScan::Target.new(url).extend(CMSScanner::Target::Server::Apache) }
  let(:url)         { 'http://ex.lo/' }
  let(:fixtures)    { File.join(FINDERS_FIXTURES, 'wp_version', 'sitemap_generator') }
  let(:sitemap_url) { url + 'sitemap.xml' }

  describe '#aggressive' do
    before { stub_request(:get, sitemap_url).to_return(body: File.read(File.join(fixtures, file))) }

    after do
      expect(target).to receive(:sub_dir).at_least(1).and_return(false)

      result = finder.aggressive

      expect(result).to eql @expected
      expect(result.interesting_entries).to eql @expected.interesting_entries if @expected
    end

    context 'when no version' do
      let(:file) { 'no_version.html' }

      it 'returns nil' do
        @expected = nil
      end
    end

    context 'when no generator' do
      let(:file) { 'no_generator.html' }

      it 'returns nil' do
        @expected = nil
      end
    end

    context 'when invalid version number' do
      let(:file) { 'invalid.html' }

      it 'returns nil' do
        @expected = nil
      end
    end

    context 'when present and valid' do
      let(:file) { '4.0.html' }

      it 'returns the expected version' do
        @expected = WPScan::WpVersion.new(
          '4.0',
          confidence: 80,
          found_by: 'Sitemap Generator (Aggressive Detection)',
          interesting_entries: [
            "#{sitemap_url}, <!-- generator=\"Wordpress/4.0\" -->"
          ]
        )
      end
    end
  end
end
