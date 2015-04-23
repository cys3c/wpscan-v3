require_relative 'wp_version/meta_generator'
require_relative 'wp_version/rss_generator'
require_relative 'wp_version/atom_generator'
require_relative 'wp_version/rdf_generator'
require_relative 'wp_version/readme'
require_relative 'wp_version/sitemap_generator'
require_relative 'wp_version/opml_generator'
require_relative 'wp_version/stylesheets'
require_relative 'wp_version/unique_fingerprinting'

module WPScan
  module Finders
    module WpVersion
      # Wp Version Finder
      class Base
        include CMSScanner::Finders::UniqueFinder

        # @param [ WPScan::Target ] target
        def initialize(target)
          finders <<
            WpVersion::MetaGenerator.new(target) <<
            WpVersion::RSSGenerator.new(target) <<
            WpVersion::AtomGenerator.new(target) <<
            WpVersion::Stylesheets.new(target) <<
            WpVersion::RDFGenerator.new(target) <<
            WpVersion::Readme.new(target) <<
            WpVersion::SitemapGenerator.new(target) <<
            WpVersion::OpmlGenerator.new(target) <<
            WpVersion::UniqueFingerprinting.new(target)
        end
      end
    end
  end
end
