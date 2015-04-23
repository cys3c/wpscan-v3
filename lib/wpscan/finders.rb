require 'wpscan/finders/finder/wp_version/smart_url_checker'
require 'wpscan/finders/finder/plugin_version/comments'

module WPScan
  # Custom Finders
  module Finders
    include CMSScanner::Finders

    # Custom InterestingFindings
    module InterestingFindings
      include CMSScanner::Finders::InterestingFindings
    end
  end
end
