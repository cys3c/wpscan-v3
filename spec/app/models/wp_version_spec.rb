require 'spec_helper'

describe WPScan::WpVersion do
  describe '#new' do
    context 'when invalid number' do
      it 'raises an error' do
        expect { described_class.new('aa') }.to raise_error WPScan::InvalidWordPressVersion
      end
    end

    context 'when valid number' do
      it 'create the instance' do
        version = described_class.new(4.0)

        expect(version).to be_a described_class
        expect(version.number).to eql '4.0'
      end
    end
  end

  describe '.valid?' do
    after { expect(described_class.valid?(@number)).to eq @expected }

    it 'returns false' do
      @number   = 'aaa'
      @expected = false
    end

    it 'returns true' do
      @number   = '4.0'
      @expected = true
    end
  end

  describe '#vulnerabilities' do
    subject(:version) { described_class.new(number) }

    context 'when no vulns' do
      let(:number) { '4.1' }

      its(:vulnerabilities) { should eql([]) }
    end

    context 'when a signle vuln' do
      let(:number) { '3.8' }

      it 'returns the expected result' do
        expected = [WPScan::Vulnerability.new(
          'WordPress 3.8 - Vuln 3',
          { url: %w(url-4), osvdb: %w(11), wpvulndb: '3' },
          'AUTHBYPASS'
        )]

        expect(version.vulnerabilities).to eq expected
        expect(version).to be_vulnerable
      end
    end

    context 'when multiple vulns' do
      let(:number) { '3.8.1' }

      xit 'returns the expected results'
    end
  end
end
