module WPScan
  module DB
    # WP Items
    class WpItems
      # @return [ Array<String> ] The slug of all items
      def self.all_slugs
        [*read_json_file(db_file)].map { |item| item['name'] }
      end

      # @return [ Array<String> ] The slug of all popular items
      def self.popular_slugs
        read_json_file(db_file).select { |item| item['popular'] == true }.map { |item| item['name'] }
      end

      # @return [ Array<String> ] The slug of all vulnerable items
      def self.vulnerable_slugs
        read_json_file(db_file).select { |item| !item['vulnerabilities'].empty? }.map { |item| item['name'] }
      end
    end
  end
end
