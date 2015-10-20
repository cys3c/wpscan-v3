require 'spec_helper'

describe WPScan::Finders::Plugins::Comments do
  subject(:finder) { described_class.new(target) }
  let(:target)     { WPScan::Target.new(url) }
  let(:url)        { 'http://wp.lab/' }
  let(:fixtures)   { File.join(FINDERS_FIXTURES, 'plugins', 'comments') }

  def plugin(name)
    WPScan::Plugin.new(name, target, found_by: 'Comments (Passive Detection)', confidence: 80)
  end

  describe '#passive' do
    after do
      stub_request(:get, target.url).to_return(body: File.read(File.join(fixtures, file)))
      expect(finder.passive).to match_array @expected
    end

    context 'when none found' do
      let(:file) { 'none.html' }

      it 'returns an empty array' do
        @expected = []
      end
    end

    context 'when found' do
      before { expect(target).to receive(:content_dir).and_return('wp-content') }

      let(:file) { 'found.html' }

      it 'returns the expected array' do
        @expected = []

        WPScan::DB::DynamicPluginFinders.comments.each do |name, _config|
          @expected << plugin(name) if name != 'rspec-failure'
        end
      end
    end
  end
end
