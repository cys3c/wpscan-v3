module WPScan
  # Custom module
  module Formatter
    include CMSScanner::Formatter

    # Module to override the CMSScanner::Formatter::Base#views_directories
    module InstanceMethods
      # @return [ Array<String> ]
      def views_directories
        unless @views_directories
          @views_directories = super

          [Dir.home, Dir.pwd].each do |path|
            @views_directories << Pathname.new(path).join('.wpscan', 'views').to_s
          end
        end

        @views_directories
      end
    end
  end
end
