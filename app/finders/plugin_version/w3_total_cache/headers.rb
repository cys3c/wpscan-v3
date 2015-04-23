module WPScan
  module Finders
    module PluginVersion
      module W3TotalCache
        # Version from Headers
        class Headers < CMSScanner::Finders::Finder
          PATTERN = %r{W3 Total Cache/([0-9.]+)}i

          # @param [ Hash ] opts
          #
          # @return [ Version ]
          def passive(_opts = {})
            headers = target.target.headers

            return unless headers && headers['X-Powered-By'].to_s =~ PATTERN

            WPScan::Version.new(
              Regexp.last_match[1],
              found_by: found_by,
              confidence: 80,
              interesting_entries: ["#{target.target.url}, #{Regexp.last_match}"]
            )
          end
        end
      end
    end
  end
end
