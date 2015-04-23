require 'spec_helper'

describe WPScan::WpItem do
  subject(:wp_item)  { described_class.new(name, target, opts) }
  let(:name)         { 'test_item' }
  let(:target)       { WPScan::Target.new(url) }
  let(:url)          { 'http://wp.lab/' }
  let(:opts)         { {} }

  its(:target) { should eql target }

  describe '#new' do
    context 'when no opts' do
      its(:name) { should eql name }
      its(:detection_opts) { should eql(mode: nil, confidence_threshold: 100) }
    end

    context 'when :mode' do
      let(:opts) { super().merge(mode: :passive, version_all: true) }

      its(:detection_opts) { should eql(mode: :passive, confidence_threshold: 0) }
    end

    context 'when the name contains encoded chars' do
      let(:name) { 'theme%212%23a' }

      its(:name) { should eql 'theme!2#a' }
    end
  end

  describe '#url' do
    context 'when no opts[:url]' do
      its(:url) { should eql nil }
    end

    context 'when opts[:url]' do
      let(:opts) { super().merge(url: item_url) }
      let(:item_url) { "#{url}item/" }

      context 'when path given' do
        it 'appends it' do
          expect(wp_item.url('path')).to eql "#{item_url}path"
        end
      end

      it 'encodes the path' do
        expect(wp_item.url('#t#')).to eql "#{item_url}%23t%23"
        expect(wp_item.url('t .txt')).to eql "#{item_url}t%20.txt"
      end
    end
  end

  describe '#==' do
    context 'when the same name' do
      it 'returns true' do
        other = described_class.new(name, target)

        expect(wp_item == other).to be true
      end
    end

    context 'when another object' do
      it 'returns false' do
        expect(wp_item == 'string').to be false
      end
    end

    context 'when different names' do
      it 'returns false' do
        other = described_class.new('another', target)

        expect(wp_item == other).to be false
      end
    end
  end

  describe '#to_s' do
    its(:to_s) { should eql name }
  end

  describe '#classify_name' do
    its(:classify_name) { should eql :TestItem }
  end

  describe '#readme_url' do
    xit
  end

  describe '#changelog_url' do
    xit
  end

  describe '#directory_listing?' do
    xit
  end

  describe '#error_log?' do
    xit
  end
end
