require 'spec_helper'

describe WPScan::Finders::PluginVersion::Base do
  subject(:plugin_version) { described_class.new(plugin) }
  let(:plugin)             { WPScan::Plugin.new(name, target) }
  let(:target)             { WPScan::Target.new('http://wp.lab/') }
  let(:name)               { 'spec' }
  let(:default_finders)    { %w(Readme) }

  describe '#finders' do
    after do
      expect(target).to receive(:content_dir).and_return('wp-content')
      expect(plugin_version.finders.map { |f| f.class.to_s.demodulize }).to eql @expected
    end

    context 'when no related specific finders' do
      it 'contains the default finders' do
        @expected = default_finders
      end
    end

    # Dynamic Version Finders are not tested here, they are in
    # - spec/app/finders/plugins/comments_specs (nothing needs to be changed)
    # - spec/app/finders/controllers/enumeration_spec (nothing needs to be changed)
    # - spec/fixtures/db/dynamic_finders.yml (add/update the pattern in there)
    # - spec/fixtures/finders/plugins/comments/found.html (add/update the HTML comments there)
    #
    # Note: versions detected by the dynamic finders are currently not tested (TODO)
    #
    # However, they should be included in the below if they have both dynamic and specific finders
    # like for the revslider plugin
    context 'when specific finders' do
      {
        'sitepress-multilingual-cms' => %w(VersionParameter MetaGenerator),
        'w3-total-cache' => %w(Headers Comments),
        'LayerSlider' => %w(TranslationFile),
        'revslider' => %w(ReleaseLog Comments)
      }.each do |plugin_name, specific_finders|
        context "when #{plugin_name} plugin" do
          let(:name) { plugin_name }

          it 'contains the expected finders' do
            @expected = default_finders + specific_finders
          end
        end
      end
    end
  end
end
