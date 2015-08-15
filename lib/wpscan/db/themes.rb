module WPScan
  module DB
    # WP Themes
    class Themes < WpItems
      # @return [ String ]
      def self.db_file
        @db_file ||= File.join(DB_DIR, 'themes.json')
      end
    end
  end
end
