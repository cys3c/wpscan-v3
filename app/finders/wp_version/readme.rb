module WPScan
  module Finders
    module WpVersion
      # Readme Version Finder
      class Readme < CMSScanner::Finders::Finder
        # @return [ WpVersion ]
        def aggressive(_opts = {})
          readme_url = target.url('readme.html') # Maybe move this into the Target ?

          node = Browser.get(readme_url).html.css('h1#logo').last

          return unless node && node.text.to_s.strip =~ /\AVersion (.*)\z/i

          number = Regexp.last_match(1)

          return unless WPScan::WpVersion.valid?(number)

          WPScan::WpVersion.new(
            number,
            found_by: 'Readme (Aggressive Detection)',
            confidence: 90,
            interesting_entries: ["#{readme_url}, Match: '#{node.text.to_s.strip}'"]
          )
        end
      end
    end
  end
end
