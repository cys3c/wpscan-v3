module WPScan
  module Finders
    module Users
      # WP JSON API
      #
      # Since 4.7 - Need more investigation as it seems WP 4.7.1 reduces the exposure, see https://github.com/wpscanteam/wpscan/issues/1038)
      #
      class WpJsonApi < CMSScanner::Finders::Finder
        # @param [ Hash ] opts
        #
        # @return [ Array<User> ]
        def aggressive(_opts = {})
          found = []

          JSON.parse(Browser.get(api_url).body).each do |user|
            found << WPScan::User.new(user['slug'], id: user['id'], found_by: found_by, confidence: 100)
          end

          found
        rescue JSON::ParserError
          found
        end

        # @return [ String ] The URL of the API listing the Users
        def api_url
          @api_url ||= target.url('wp-json/wp/v2/users/')
        end
      end
    end
  end
end
