module WPScan
  module DB
    # WP Items
    class WpItems
      # @return [ Array<String> ] The slug of all items
      def self.all_slugs
        [*db].map { |item| item['name'] }
      end

      # @return [ Array<String> ] The slug of all popular items
      def self.popular_slugs
        db.select { |item| item['popular'] == true }.map { |item| item['name'] }
      end

      # @return [ Array<String> ] The slug of all vulnerable items
      def self.vulnerable_slugs
        db.select { |item| !item['vulnerabilities'].empty? }.map { |item| item['name'] }
      end
    end
  end
end
