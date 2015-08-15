module WPScan
  module DB
    # WP Version
    class Version
      def self.db_file
        @db_file ||= File.join(DB_DIR, 'wordpresses.json')
      end

      # @param [ String ] identifier The plugin/theme slug or version number
      #
      # @return [ Hash ] The JSON data from the DB associated to the identifier
      def self.db_data(identifier)
        read_json_file(db_file).each do |json|
          asset = json['version'] # || json['name']

          return json if asset == identifier
        end

        {} # no item found, empty hash returned
      end
    end
  end
end
