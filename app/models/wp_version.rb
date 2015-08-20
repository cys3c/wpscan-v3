module WPScan
  # WP Version
  class WpVersion < CMSScanner::Version
    include Vulnerable
    attr_reader :db_data

    def initialize(number, opts = {})
      fail InvalidWordPressVersion unless WpVersion.valid?(number.to_s)

      super(number, opts)
    end

    # @param [ String ] number
    #
    # @return [ Boolean ] true if the number is a valid WP version, false otherwise
    def self.valid?(number)
      all.include?(number)
    end

    # @return [ Array<String> ] All the version numbers
    def self.all
      return @all_numbers if @all_numbers

      @all_numbers = []

      DB::Version.all.each { |v| @all_numbers << v.number }

      @all_numbers
    end

    # @return [ JSON ]
    def db_data
      DB::Version.db_data(number)
    end

    # @return [ Array<Vulnerability> ]
    def vulnerabilities
      return @vulnerabilities if @vulnerabilities

      @vulnerabilities = []

      [*db_data['vulnerabilities']].each do |json_vuln|
        @vulnerabilities << Vulnerability.load_from_json(json_vuln)
      end

      @vulnerabilities
    end
  end
end
