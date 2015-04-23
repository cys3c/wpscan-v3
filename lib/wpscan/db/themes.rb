module WPScan
  module DB
    # WP Themes
    class Themes
      # @return [ String ]
      def self.vulns_file
        @vulns_file ||= File.join(DB_DIR, 'theme_vulns.json')
      end

      # @return [ Array<String> ]
      def self.vulnerable_names
        read_json_file(vulns_file).reduce([]) { |a, e| a << e.keys.first }
      end
    end
  end
end
