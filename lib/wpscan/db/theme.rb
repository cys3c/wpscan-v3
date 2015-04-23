module WPScan
  module DB
    # Theme DB
    class Theme < WpItem
      # @return [ String ]
      def self.vulns_file
        @vulns_file ||= File.join(DB_DIR, 'theme_vulns.json')
      end
    end
  end
end
