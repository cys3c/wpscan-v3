module WPScan
  module Finders
    module ThemeVersion
      # Theme Version Finder from the style.css file
      class Style < CMSScanner::Finders::Finder
        # @param [ Hash ] opts
        #
        # @return [ Version ]
        def passive(_opts = {})
          return unless cached_style?

          style_version
        end

        # @param [ Hash ] opts
        #
        # @return [ Version ]
        def aggressive(_opts = {})
          return if cached_style?

          style_version
        end

        # @return [ Boolean ]
        def cached_style?
          # TODO: remove the method: once https://github.com/wpscanteam/CMSScanner/issues/28 has been done
          Typhoeus::Config.cache.get(browser.forge_request(target.style_url, method: :get)) ? true : false
        end

        # @return [ Version ]
        def style_version
          return unless Browser.get(target.style_url).body =~ /Version:\s*([^\s]+)/i

          WPScan::Version.new(
            Regexp.last_match[1],
            found_by: found_by,
            confidence: 80,
            interesting_entries: ["#{target.style_url}, #{Regexp.last_match}"]
          )
        end
      end
    end
  end
end
