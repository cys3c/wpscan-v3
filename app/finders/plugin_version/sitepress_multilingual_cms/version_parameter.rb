module WPScan
  module Finders
    module PluginVersion
      module SitepressMultilingualCms
        # Version from the v parameter in href / src of stylesheets / scripts
        class VersionParameter < CMSScanner::Finders::Finder
          # @param [ Hash ] opts
          #
          # @return [ Version ]
          def passive(_opts = {})
            pattern = %r{#{Regexp.escape(target.target.plugins_dir)}/sitepress-multilingual-cms/}i

            target.target.in_scope_urls(Browser.get(target.target.url), '//link|//script') do |url|
              uri = Addressable::URI.parse(url)

              next unless uri.path =~ pattern && uri.query =~ /v=([0-9\.]+)/

              return WPScan::Version.new(
                Regexp.last_match[1],
                found_by: found_by,
                confidence: 50,
                interesting_entries: [url]
              )
            end
            nil
          end
        end
      end
    end
  end
end
