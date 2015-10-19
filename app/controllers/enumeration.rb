require_relative 'enumeration/cli_options'
require_relative 'enumeration/enum_methods'

module WPScan
  module Controller
    # Enumeration Controller
    class Enumeration < CMSScanner::Controller::Base
      def before_scan
        # Create the Dynamic Finders
        dynamic_finders_config['plugins'].each do |name, config|
          %w(Comments).each do |klass|
            next unless config[klass] && config[klass]['version']

            constant_name = name.tr('-', '_').camelize

            unless Finders::PluginVersion.constants.include?(constant_name.to_sym)
              Finders::PluginVersion.const_set(constant_name, Module.new)
            end

            mod = WPScan::Finders::PluginVersion.const_get(constant_name)

            fail "#{mod} has already a #{klass} class" if mod.constants.include?(klass.to_sym)

            case klass
            when 'Comments' then create_plugins_comments_finders(mod, config[klass])
            end
          end
        end
      end

      def create_plugins_comments_finders(mod, config)
        mod.const_set(
          :Comments, Class.new(Finders::Finder::PluginVersion::Comments) do
            const_set(:PATTERN, Regexp.new(config['pattern'], Regexp::IGNORECASE))
          end
        )
      end

      def run
        enum = parsed_options[:enumerate] || {}

        enum_plugins if enum_plugins?(enum)
        enum_themes  if enum_themes?(enum)

        [:timthumbs, :config_backups, :medias].each do |key|
          send("enum_#{key}".to_sym) if enum.key?(key)
        end

        enum_users if enum_users?(enum)
      end
    end
  end
end
