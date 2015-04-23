module WPScan
  module Finders
    module WpVersion
      # Sitemap Generator Version Finder
      class SitemapGenerator < CMSScanner::Finders::Finder
        # @return [ WpVersion ]
        def aggressive(_opts = {})
          target.comments_from_page(%r{\Agenerator="wordpress/([^"]+)"\z}i, 'sitemap.xml') do |match, node|
            next unless WPScan::WpVersion.valid?(match[1])

            return WPScan::WpVersion.new(
              match[1],
              found_by: 'Sitemap Generator (Aggressive Detection)',
              confidence: 80,
              interesting_entries: ["#{target.url('sitemap.xml')}, #{node}"]
            )
          end
          nil
        end
      end
    end
  end
end
