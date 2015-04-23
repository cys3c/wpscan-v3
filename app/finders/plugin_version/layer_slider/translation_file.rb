module WPScan
  module Finders
    module PluginVersion
      module LayerSlider
        # Version from a Translation file
        #
        # See https://github.com/wpscanteam/wpscan/issues/765
        class TranslationFile < CMSScanner::Finders::Finder
          # @param [ Hash ] opts
          #
          # @return [ Version ]
          def aggressive(_opts = {})
            potential_urls.each do |url|
              res = Browser.get(url)

              next unless res.code == 200 && res.body =~ /Project-Id-Version: LayerSlider WP v?([0-9\.][^\\\s]+)/

              return WPScan::Version.new(
                Regexp.last_match[1],
                found_by: 'Translation File (Aggressive Detection)',
                confidence: 90,
                interesting_entries: ["#{url}, #{Regexp.last_match}"]
              )
            end
            nil
          end

          # @return [ Array<String> ] The potential URLs where the version is disclosed
          def potential_urls
            # Recent versions seem to use the 'locales' directory instead of the 'languages' one.
            # Maybe also check other locales ?
            %w(locales languages).reduce([]) do |a, e|
              a << target.url("#{e}/LayerSlider-en_US.po")
            end
          end
        end
      end
    end
  end
end
