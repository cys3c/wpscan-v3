module WPScan
  module DB
    # Plugin DB
    class Plugin < WpItem
      # @return [ String ]
      def self.vulns_file
        @vulns_file ||= File.join(DB_DIR, 'plugin_vulns.json')
      end
    end
  end
end
