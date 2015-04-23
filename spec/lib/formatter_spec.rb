require 'spec_helper'

describe WPScan::Formatter do
  describe '#views_directories' do
    let(:expected) do
      [CMSScanner::APP_DIR, WPScan::APP_DIR].reduce([]) do |a, p|
        a << File.join(p, 'views')
      end + [Dir.home, Dir.pwd].reduce([]) { |a, e| a << File.join(e, '.wpscan', 'views') }
    end

    described_class.availables.each do |format|
      context "when #{format} formatter" do
        it 'has the correct 4 directories' do
          expect(described_class.load(format).views_directories).to eq expected
        end
      end
    end
  end
end
