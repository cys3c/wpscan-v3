module WPScan
  module Finders
    module Plugins
      # Plugins from Headers Finder
      class Headers < CMSScanner::Finders::Finder
        # @param [ Hash ] opts
        #
        # @return [ Array<Plugin> ]
        def passive(opts = {})
          plugin_names_from_headers(opts).reduce([]) do |a, e|
            a << WPScan::Plugin.new(e, target, opts.merge(found_by: found_by, confidence: 60))
          end
        end

        # X-Powered-By: W3 Total Cache/0.9.2.5
        # WP-Super-Cache: Served supercache file from PHP
        #
        # @return [ Array<String> ]
        def plugin_names_from_headers(_opts = {})
          found   = []
          headers = Browser.get(target.url).headers

          if headers
            powered_by     = headers['X-Powered-By'].to_s
            wp_super_cache = headers['wp-super-cache'].to_s

            found << 'w3-total-cache' if powered_by =~ Finders::PluginVersion::W3TotalCache::Headers::PATTERN
            found << 'wp-super-cache' if wp_super_cache =~ /supercache/i
          end

          found
        end
      end
    end
  end
end
