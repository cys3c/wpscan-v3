module WPScan
  module Finders
    module MainTheme
      # URLs In Homepage Finder
      class UrlsInHomepage < CMSScanner::Finders::Finder
        include WpItems::URLsInHomepage

        # @param [ Hash ] opts
        #
        # @return [ Array<Theme> ]
        def passive(opts = {})
          found = []

          names = items_from_links('themes', false) + items_from_codes('themes', false)

          names.each_with_object(Hash.new(0)) { |name, counts| counts[name] += 1 }.each do |name, occurences|
            found << WPScan::Theme.new(name, target, opts.merge(found_by: found_by, confidence: 2 * occurences))
          end

          found
        end
      end
    end
  end
end
