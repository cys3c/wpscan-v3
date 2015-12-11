module WPScan
  module Finders
    module WpVersion
      # Stylesheets Version Finder
      class Stylesheets < CMSScanner::Finders::Finder
        # @return [ WpVersion ]
        def passive(_opts = {})
          found = []

          scan_page(target.homepage_url).each do |version_number, occurences|
            next unless WPScan::WpVersion.valid?(version_number) # Skip invalid versions

            found << WPScan::WpVersion.new(
              version_number,
              found_by: 'Stylesheet Numbers (Passive Detection)',
              confidence: 5 * occurences,
              interesting_entries: [target.homepage_url]
            )
          end

          found
        end

        protected

        # TODO: use target.in_scope_urls to get the URLs
        # @param [ String ] url
        #
        # @return [ Hash ]
        def scan_page(url)
          found   = {}
          pattern = /\bver=([0-9\.]+)/i

          Browser.get(url).html.css('link,script').each do |tag|
            %w(href src).each do |attribute|
              attr_value = tag.attribute(attribute).to_s

              next if attr_value.nil? || attr_value.empty?

              uri = Addressable::URI.parse(attr_value)
              next unless uri.query && uri.query.match(pattern)

              version = Regexp.last_match[1].to_s

              found[version] ||= 0
              found[version] += 1
            end
          end

          found
        end
      end
    end
  end
end
