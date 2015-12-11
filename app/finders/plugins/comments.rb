module WPScan
  module Finders
    module Plugins
      # Plugins from Comments Finder
      class Comments < CMSScanner::Finders::Finder
        # @param [ Hash ] opts
        # @option opts [ Boolean ] :unique Default: true
        #
        # @return [ Array<Plugin> ]
        def passive(opts = {})
          found         = []
          opts[:unique] = true unless opts.key?(:unique)

          target.homepage_res.html.xpath('//comment()').each do |node|
            comment = node.text.to_s.strip

            DB::DynamicPluginFinders.comments.each do |name, config|
              next unless comment =~ config['pattern']

              plugin = WPScan::Plugin.new(name, target, opts.merge(found_by: found_by, confidence: 70))

              found << plugin unless opts[:unique] && found.include?(plugin)
            end
          end

          found
        end
      end
    end
  end
end
