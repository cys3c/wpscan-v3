module WPScan
  module Finders
    class Finder
      module PluginVersion
        # Plugin Version from the Comments in the homepage, used in dynamic PluginVersion finders
        class Comments < CMSScanner::Finders::Finder
          def passive(_opts = {})
            target.target.comments_from_page(self.class::PATTERN) do |match|
              # Avoid nil version, i.e a pattern allowing both versionable and non
              # versionable string to be detected
              next unless match[1]

              return WPScan::Version.new(
                match[1],
                found_by: found_by,
                confidence: 80,
                interesting_entries: ["#{target.target.url}, Match: '#{match}'"]
              )
            end
          end
        end
      end
    end
  end
end
