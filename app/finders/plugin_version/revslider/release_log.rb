module WPScan
  module Finders
    module PluginVersion
      module Revslider
        # Version from the release_log.html
        #
        # See https://github.com/wpscanteam/wpscan/issues/817
        class ReleaseLog < CMSScanner::Finders::Finder
          # @param [ Hash ] opts
          #
          # @return [ Version ]
          def aggressive(_opts = {})
            res = Browser.get(release_log_url)

            res.html.css('h3.version-number:first').each do |node|
              next unless node.text =~ /\AVersion ([0-9\.]+).*\z/i

              return WPScan::Version.new(
                Regexp.last_match[1],
                found_by: found_by,
                confidence: 90,
                interesting_entries: ["#{release_log_url}, #{Regexp.last_match}"]
              )
            end
            nil
          end

          def release_log_url
            target.url('release_log.html')
          end
        end
      end
    end
  end
end
