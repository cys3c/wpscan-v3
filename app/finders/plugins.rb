require_relative 'plugins/urls_in_homepage'
require_relative 'plugins/headers'
require_relative 'plugins/comments'
require_relative 'plugins/known_locations'

module WPScan
  module Finders
    module Plugins
      # Plugins Finder
      class Base
        include CMSScanner::Finders::SameTypeFinder

        # @param [ WPScan::Target ] target
        def initialize(target)
          finders <<
            Plugins::UrlsInHomepage.new(target) <<
            Plugins::Headers.new(target) <<
            Plugins::Comments.new(target) <<
            Plugins::KnownLocations.new(target)
        end
      end
    end
  end
end
