require 'spec_helper'

describe WPScan::Finders::Plugins::Comments do
  subject(:finder) { described_class.new(target) }
  let(:target)     { WPScan::Target.new(url) }
  let(:url)        { 'http://wp.lab/' }
  let(:fixtures)   { File.join(FINDERS_FIXTURES, 'plugins', 'comments') }

  def plugin(name)
    WPScan::Plugin.new(name, target, found_by: 'Comments (Passive Detection)', confidence: 70)
  end

  describe '#passive' do
    after do
      stub_request(:get, target.url).to_return(body: File.read(File.join(fixtures, file)))
      expect(finder.passive(opts)).to match_array @expected
    end

    let(:opts) { {} }

    context 'when none found' do
      let(:file) { 'none.html' }

      it 'returns an empty array' do
        @expected = []
      end
    end

    context 'when found' do
      before { expect(target).to receive(:content_dir).and_return('wp-content') }

      let(:file) { 'found.html' }
      let(:unique_expected) do
        expected = []

        WPScan::DB::DynamicPluginFinders.comments.each do |name, _config|
          expected << plugin(name) if name != 'rspec-failure'
        end

        expected
      end

      context 'when no opts[:unique]' do
        it 'returns the array w/o duplicate (:unique is true by default)' do
          @expected = unique_expected
        end
      end

      context 'when opts[:unique] = false' do
        let(:opts) { { unique: false } }

        it 'returns the array with all plugins, including those detected more than once' do
          @expected = unique_expected

          # Adds the plugins detected more than once (due to pattern variations)
          %w(
            all-in-one-seo-pack google-analytics-for-wordpress nginx-helper optin-monster revslider
            wordpress-seo wordpress-seo wp-piwik wp-piwik wp-piwik wp-spamfree
          ).each do |p|
            @expected << plugin(p)
          end
        end
      end
    end
  end
end
