module WPScan
  # Override to add the config file locations
  # to look for (~home | pwd)/.wpscan/config.(json|yml)
  class Controllers < CMSScanner::Controllers
    def initialize(option_parser = OptParseValidator::OptParser.new(nil, 45))
      super(option_parser)

      [Dir.home, Dir.pwd].each do |dir|
        %w(json yml).each do |ext|
          @option_parser.options_files << File.join(dir, '.wpscan', "config.#{ext}")
        end
      end
    end
  end
end
