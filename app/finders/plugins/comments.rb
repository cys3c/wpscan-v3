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

            patterns.each do |name, pattern|
              next unless comment =~ pattern

              plugin = WPScan::Plugin.new(name, target, opts.merge(found_by: found_by, confidence: 70))

              found << plugin unless found.include?(plugin)
            end
          end

          found
        end

        # @return [ Hash ]
        def patterns
          return @patterns if @pattern

          @patterns = {}

          dynamic_finders_config['plugins'].each do |name, config|
            next unless config['Comments']

            @patterns[name] = Regexp.new(config['Comments']['pattern'], Regexp::IGNORECASE)
          end

          @patterns
        end
      end
    end
  end
end
