require 'spec_helper'

describe WPScan::Finders::Plugins::UrlsInHomepage do
  subject(:finder) { described_class.new(target) }
  let(:target)     { WPScan::Target.new(url) }
  let(:url)        { 'http://wp.lab/' }
  let(:fixtures)   { File.join(FINDERS_FIXTURES, 'plugins', 'urls_in_homepage') }

  it_behaves_like 'App::Finders::WpItems::URLsInHomepage' do
    let(:type)                { 'plugins' }
    let(:uniq_links)          { true }
    let(:uniq_codes)          { true }
    let(:expected_from_links) { (1..4).map { |i| "dl-#{i}" } }
    let(:expected_from_codes) { (1..6).map { |i| "dc-#{i}" } }
  end

  describe '#passive' do
    xit
  end
end
