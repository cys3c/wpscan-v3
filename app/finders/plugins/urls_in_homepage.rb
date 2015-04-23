module WPScan
  module Finders
    module Plugins
      # URLs In Homepage Finder
      class UrlsInHomepage < CMSScanner::Finders::Finder
        include WpItems::URLsInHomepage

        # @param [ Hash ] opts
        #
        # @return [ Array<Plugin> ]
        def passive(opts = {})
          found = []

          (items_from_links('plugins') + items_from_codes('plugins')).uniq.sort.each do |name|
            found << WPScan::Plugin.new(name, target, opts.merge(found_by: found_by, confidence: 80))
          end

          found
        end
      end
    end
  end
end
