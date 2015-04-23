module WPScan
  module Finders
    module WpVersion
      # Meta Generator Version Finder
      class MetaGenerator < CMSScanner::Finders::Finder
        # @return [ WpVersion ]
        def passive(_opts = {})
          Browser.get(target.url).html.css('meta[name="generator"]').each do |node|
            next unless node.attribute('content').to_s =~ /wordpress (.*)/i

            number = Regexp.last_match(1)

            next unless WPScan::WpVersion.valid?(number)

            return WPScan::WpVersion.new(
              number,
              found_by: 'Meta Generator (Passive detection)',
              confidence: 80,
              interesting_entries: ["#{target.url}, #{node}"]
            )
          end
          nil
        end
      end
    end
  end
end
