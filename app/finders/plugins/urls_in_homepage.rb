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
            found << Plugin.new(name, target, opts.merge(found_by: found_by, confidence: 80))
          end

          DB::DynamicPluginFinders.urls_in_page.each do |name, config|
            next unless target.homepage_res.html.xpath(config['xpath']).any?

            found << Plugin.new(name, target, opts.merge(found_by: found_by, confidence: 100))
          end

          found
        end
      end
    end
  end
end
