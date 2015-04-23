module WPScan
  module DB
    # WpItem - super DB class for Plugin & Theme
    # TODO: factorise this class with the wp_version one
    class WpItem
      # @param [ WPscan::WpItem ] wp_item
      #
      # @return [ Array<Vulnerabily> ]
      def self.vulnerabilities(wp_item)
        vulnerabilities = []

        read_json_file(vulns_file).each do |item|
          asset = item[wp_item.name]

          next unless asset

          asset['vulnerabilities'].each do |json_vuln|
            vulnerability = Vulnerability.load_from_json(json_vuln)
            vulnerabilities << vulnerability if vulnerable_to?(wp_item, vulnerability)
          end

          break # no need to iterate any further
        end

        vulnerabilities
      end

      # Checks if the wp_item is vulnerable to a specific vulnerability
      #
      # @param [ WPscan::WpItem ] wp_item
      # @param [ Vulnerability ] vuln Vulnerability to check the item against
      #
      # @return [ Boolean ]
      def self.vulnerable_to?(wp_item, vuln)
        return true unless wp_item.version && vuln && vuln.fixed_in && !vuln.fixed_in.empty?

        wp_item.version < vuln.fixed_in ? true : false
      end
    end
  end
end
