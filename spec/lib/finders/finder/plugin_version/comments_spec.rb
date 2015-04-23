require 'spec_helper'

describe WPScan::Finders::Finder::PluginVersion::Comments do
  module WPScan
    module Rspec
      module Finders
        module PluginVersion
          # Spec class to have a custom PATTERN
          class Comments < WPScan::Finders::Finder::PluginVersion::Comments
            PATTERN = /some version: ([\d\.]+)/i
          end
        end
      end
    end
  end

  subject(:finder) { WPScan::Rspec::Finders::PluginVersion::Comments.new(plugin) }
  let(:plugin)     { WPScan::Plugin.new('spec', target) }
  let(:target)     { WPScan::Target.new('http://wp.lab/') }
  let(:fixtures)   { File.join(FINDERS_FIXTURES, 'plugin_version', 'comments') }

  describe '#passive' do
    before { stub_request(:get, target.url).to_return(body: File.read(File.join(fixtures, 'index.html'))) }

    it 'returns the expected Version' do
      version = finder.passive

      expect(version).to eql WPScan::Version.new(
        '1.5',
        confidence: 80,
        found_by: 'Comments (Passive Detection)',
        interesting_entries: ["#{target.url}, Some version: 1.5"]
      )
    end
  end
end
