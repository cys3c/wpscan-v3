module WPScan
  module Finders
    module Plugins
      # Plugins from Comments Finder
      class Comments < CMSScanner::Finders::Finder
        # @param [ Hash ] opts
        #
        # @return [ Array<Plugin> ]
        def passive(opts = {})
          found = []

          Browser.get(target.url).html.xpath('//comment()').each do |node|
            comment = node.text.to_s

            DB::DynamicPluginFinders.comments.each do |name, config|
              next unless comment =~ config['pattern']

              plugin = WPScan::Plugin.new(name, target, opts.merge(found_by: found_by, confidence: 70))

              found << plugin unless found.include?(plugin)
            end
          end

          found
        end
      end
    end
  end
end
