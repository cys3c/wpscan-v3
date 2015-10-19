module WPScan
  module Finders
    module Plugins
      # URLs In Homepage Finder
      class UrlsInHomepage < CMSScanner::Finders::Finder
        include WpItems::URLsInHomepage

        def homepage
          @homepage ||= Browser.get(target.url).html
        end

        # @param [ Hash ] opts
        #
        # @return [ Array<Plugin> ]
        def passive(opts = {})
          found = []

          (items_from_links('plugins') + items_from_codes('plugins')).uniq.sort.each do |name|
            found << WPScan::Plugin.new(name, target, opts.merge(found_by: found_by, confidence: 80))
          end

          xpath_matches.each do |name, _config|
            found << WPScan::Plugin.new(name, target, opts.merge(found_by: found_by, confidence: 100))
          end

          found
        end

        def xpath_matches
          dynamic_finders_config['plugins'].select do |_name, config|
            config['UrlsInHomepage'] && homepage.xpath(config['UrlsInHomepage']['xpath']).any?
          end
        end
      end
    end
  end
end
