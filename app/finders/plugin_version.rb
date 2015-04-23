require_relative 'plugin_version/readme'
# Plugins Specific
require_relative 'plugin_version/layer_slider/translation_file'
require_relative 'plugin_version/sitepress_multilingual_cms/version_parameter'
require_relative 'plugin_version/sitepress_multilingual_cms/meta_generator'
require_relative 'plugin_version/w3_total_cache/headers'

module WPScan
  module Finders
    module PluginVersion
      # Plugin Version Finder
      class Base
        include CMSScanner::Finders::UniqueFinder

        # @param [ WPScan::Plugin ] plugin
        def initialize(plugin)
          finders << PluginVersion::Readme.new(plugin)

          load_specific_finders(plugin)
        end

        # Load the finders associated with the plugin
        #
        # @param [ WPScan::Plugin ] plugin
        def load_specific_finders(plugin)
          module_name = plugin.classify_name.to_sym

          return unless Finders::PluginVersion.constants.include?(module_name)

          mod = Finders::PluginVersion.const_get(module_name)

          mod.constants.each do |constant|
            c = mod.const_get(constant)

            next unless c.is_a?(Class)

            finders << c.new(plugin)
          end
        end
      end
    end
  end
end
