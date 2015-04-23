module WPScan
  module DB
    # WP Version
    class Version
      # @return [ String ]
      def self.vulns_file
        @vulns_file ||= File.join(DB_DIR, 'wp_vulns.json')
      end

      def self.vulnerabilities(number)
        vulnerabilities = []

        read_json_file(vulns_file).each do |item|
          asset = item[number]

          next unless asset

          asset['vulnerabilities'].each do |json_vuln|
            vulnerabilities << Vulnerability.load_from_json(json_vuln)
          end
          break # no need to iterate any further
        end

        vulnerabilities
      end
    end
  end
end
