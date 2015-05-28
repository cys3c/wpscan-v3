module WPScan
  module Finders
    module PluginVersion
      module SitepressMultilingualCms
        # Version from the meta generator
        class MetaGenerator < CMSScanner::Finders::Finder
          # @param [ Hash ] opts
          #
          # @return [ Version ]
          def passive(_opts = {})
            Browser.get(target.target.url).html.css('meta[name="generator"]').each do |node|
              next unless node['content'] =~ /\AWPML\sver:([0-9\.]+)\sstt/i

              return WPScan::Version.new(
                Regexp.last_match(1),
                found_by: 'Meta Generator (Passive detection)',
                confidence: 50,
                interesting_entries: ["#{target.target.url}, Match: '#{node}'"]
              )
            end
            nil
          end
        end
      end
    end
  end
end
