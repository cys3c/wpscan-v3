module WPScan
  module DB
    # WP Plugins
    class Plugins < WpItems
      # @return [ String ]
      def self.db_file
        @db_file ||= File.join(DB_DIR, 'plugins.json')
      end
    end
  end
end
