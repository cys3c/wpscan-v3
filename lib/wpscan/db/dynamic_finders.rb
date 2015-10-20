module WPScan
  module DB
    # Dynamic Finders
    class DynamicFinders
      # @return [ String ]
      def self.db_file
        @db_file ||= File.join(DB_DIR, 'dynamic_finders.yml')
      end

      # @return [ Hash ]
      def self.db_data
        @db_data ||= YAML.load_file(db_file)
      end

      # @return [ Hash ]
      def self.finder_configs(finder_klass)
        configs = {}

        db_data.each do |slug, config|
          next unless config[finder_klass]

          configs[slug] = config[finder_klass].dup
        end

        configs
      end
    end

    # Dynamic Plugin Finders
    class DynamicPluginFinders < DynamicFinders
      # @return [ Hash ]
      def self.db_data
        @db_data ||= super['plugins'] || {}
      end

      # @return [ Hash ]
      def self.comments
        unless @comments
          @comments = finder_configs('Comments')

          @comments.each do |slug, config|
            @comments[slug]['pattern'] = Regexp.new(config['pattern'], Regexp::IGNORECASE)
          end
        end

        @comments
      end

      # @return [ Hash ]
      def self.urls_in_page
        @urls_in_page ||= finder_configs('UrlsInPage')
      end
    end

    # Dynamic Theme Finders (none ATM)
    class DynamicThemeFinders < DynamicFinders
      # @return [ Hash ]
      def self.db_data
        @db_data ||= super['themes'] || {}
      end
    end
  end
end
