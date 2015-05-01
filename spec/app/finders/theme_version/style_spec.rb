require 'spec_helper'

describe WPScan::Finders::ThemeVersion::Style do
  subject(:finder) { described_class.new(theme) }
  let(:theme)      { WPScan::Theme.new('spec', target) }
  let(:target)     { WPScan::Target.new('http://wp.lab/') }
  let(:fixtures)   { File.join(FINDERS_FIXTURES, 'theme_version', 'style') }

  before do
    expect(target).to receive(:content_dir).at_least(1).and_return('wp-content')
    stub_request(:get, /.*.css/)
  end

  describe '#passive' do
    before { expect(finder).to receive(:cached_style?).and_return(cached?) }
    after  { finder.passive }

    context 'when the style_url request has been cached' do
      let(:cached?) { true }

      it 'calls the style_version' do
        expect(finder).to receive(:style_version)
      end
    end

    context 'when the style_url request has not been cached' do
      let(:cached?) { false }

      it 'returns nil' do
        expect(finder).to_not receive(:style_version)
      end
    end
  end

  describe '#aggressive' do
    before { expect(finder).to receive(:cached_style?).and_return(cached?) }
    after  { finder.aggressive }

    context 'when the style_url request has been cached' do
      let(:cached?) { true }

      it 'returns nil' do
        expect(finder).to_not receive(:style_version)
      end
    end

    context 'when the style_url request has not been cached' do
      let(:cached?) { false }

      it 'calls the style_version' do
        expect(finder).to receive(:style_version)
      end
    end
  end

  describe '#cached_style?' do
    it 'calls the Cache with the correct arguments' do
      # Find a way to test that
      expect(Typhoeus::Config.cache).to receive(:cache).with(yolo: 'yy')
      finder.style_version
    end
  end
end
