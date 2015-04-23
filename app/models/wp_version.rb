module WPScan
  # WP Version
  class WpVersion < CMSScanner::Version
    include Vulnerable

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
      unless @all_numbers
        @all_numbers = []

        DB::Version.all.each do |v|
          @all_numbers << v.number
        end
      end
      @all_numbers
    end

    # @return [ Array<Vulnerability> ]
    def vulnerabilities
      DB::Version.vulnerabilities(number)
    end
  end
end
