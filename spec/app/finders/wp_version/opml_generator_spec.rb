require 'spec_helper'

describe WPScan::Finders::WpVersion::OpmlGenerator do
  subject(:finder) { described_class.new(target) }
  let(:target)     { WPScan::Target.new(url).extend(CMSScanner::Target::Server::Apache) }
  let(:url)        { 'http://e.org/' }
  let(:fixtures)   { File.join(FINDERS_FIXTURES, 'wp_version', 'opml_generator') }
  let(:opml_url)   { url + 'wp-links-opml.php' }

  describe '#aggressive' do
    before { stub_request(:get, opml_url).to_return(body: File.read(File.join(fixtures, file))) }

    after do
      expect(target).to receive(:sub_dir).at_least(1).and_return(false)

      result = finder.aggressive

      expect(result).to eql @expected
      expect(result.interesting_entries).to eql @expected.interesting_entries if @expected
    end

    context 'when no generator' do
      let(:file) { 'no_generator.php' }

      it 'returns nil' do
        @expected = nil
      end
    end

    context 'when invalid version number' do
      let(:file) { 'invalid.php' }

      it 'returns nil' do
        @expected = nil
      end
    end

    context 'when present and valid' do
      let(:file) { '4.0.php' }

      it 'returns the expected version' do
        @expected = WPScan::WpVersion.new(
          '4.0',
          confidence: 80,
          found_by: 'OPML Generator (Aggressive Detection)',
          interesting_entries: [
            "#{opml_url}, <!-- generator=\"WordPress/4.0\" -->"
          ]
        )
      end
    end
  end
end
