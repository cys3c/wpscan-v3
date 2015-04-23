require 'spec_helper'

describe WPScan::Finders::PluginVersion::W3TotalCache::Headers do
  subject(:finder) { described_class.new(plugin) }
  let(:plugin)     { WPScan::Plugin.new('w3-total-cache', target) }
  let(:target)     { WPScan::Target.new('http://wp.lab/') }
  # let(:fixtures)   { File.join(FINDERS_FIXTURES, 'plugin_version', 'w3_total_cache', 'headers') }

  describe '#passive' do
    xit
  end
end
