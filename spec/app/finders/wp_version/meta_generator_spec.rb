require 'spec_helper'

describe WPScan::Finders::WpVersion::MetaGenerator do
  subject(:finder) { described_class.new(target) }
  let(:target)     { WPScan::Target.new(url).extend(CMSScanner::Target::Server::Apache) }
  let(:url)        { 'http://ex.lo/' }
  let(:fixtures)   { File.join(FINDERS_FIXTURES, 'wp_version', 'meta_generator') }

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

      context 'when invalid number' do
        let(:body) { File.read(File.join(fixtures, 'invalid.html')) }

        it 'returns nil' do
          @expected = nil
        end
      end

      context 'when valid number' do
        let(:body) { File.read(File.join(fixtures, '4.0.html')) }

        it 'returns the expected version' do
          @expected = WPScan::WpVersion.new(
            '4.0',
            confidence: 80,
            found_by: 'Meta Generator (Passive detection)',
            interesting_entries: [
              "http://ex.lo/, Match: '<meta name=\"generator\" content=\"WordPress 4.0\">'"
            ]
          )
        end

        context 'when mobile pack format' do
          let(:body) { File.read(File.join(fixtures, 'mobile_pack.html')) }

          it 'returns the expecetd version' do
            @expected = WPScan::WpVersion.new(
              '4.0',
              confidence: 80,
              found_by: 'Meta Generator (Passive detection)',
              interesting_entries: [
                "http://ex.lo/, Match: '<meta name=\"generator\" content=\"WordPress 4.0, " \
                "fitted with the WordPress Mobile Pack 1.2.5\">'"
              ]
            )
          end
        end
      end
    end
  end
end
