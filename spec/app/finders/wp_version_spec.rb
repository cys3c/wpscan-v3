require 'spec_helper'

describe WPScan::Finders::WpVersion::Base do
  subject(:wp_version) { described_class.new(target) }
  let(:target)         { WPScan::Target.new(url) }
  let(:url)            { 'http://ex.lo/' }

  describe '#finders' do
    let(:expected) do
      %w(
        MetaGenerator RSSGenerator AtomGenerator Stylesheets RDFGenerator Readme
        SitemapGenerator OpmlGenerator UniqueFingerprinting
      )
    end

    it 'contains the expected finders' do
      expect(wp_version.finders.map { |f| f.class.to_s.demodulize }).to eq expected
    end
  end
end
