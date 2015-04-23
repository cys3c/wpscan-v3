module WPScan
  module DB
    # WP Plugins
    class Plugins
      # @return [ String ]
      def self.vulns_file
        @vulns_file ||= File.join(DB_DIR, 'plugin_vulns.json')
      end

      # @return [ Array<String> ]
      def self.vulnerable_names
        read_json_file(vulns_file).reduce([]) { |a, e| a << e.keys.first }
      end
    end
  end
end
