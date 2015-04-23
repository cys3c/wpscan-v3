require 'wpscan/target/platform/wordpress'

module WPScan
  # Includes the WordPress Platform
  class Target < CMSScanner::Target
    include Platform::WordPress

    # @param [ Hash ] opts
    #
    # @return [ WpVersion, false ] The WpVersion found or false if not detected
    def wp_version(opts = {})
      @wp_version = Finders::WpVersion::Base.find(self, opts) if @wp_version.nil?

      @wp_version
    end

    # @param [ Hash ] opts
    #
    # @return [ Theme ]
    def main_theme(opts = {})
      @main_theme = Finders::MainTheme::Base.find(self, opts) if @main_theme.nil?

      @main_theme
    end

    # @param [ Hash ] opts
    #
    # @return [ Array<Plugin> ]
    def plugins(opts = {})
      @plugins ||= Finders::Plugins::Base.find(self, opts)
    end

    # @param [ Hash ] opts
    #
    # @return [ Array<Theme> ]
    def themes(opts = {})
      @themes ||= Finders::Themes::Base.find(self, opts)
    end

    # @param [ Hash ] opts
    #
    # @return [ Array<Timthumb> ]
    def timthumbs(opts = {})
      @timthumbs ||= Finders::Timthumbs::Base.find(self, opts)
    end

    # @param [ Hash ] opts
    #
    # @return [ Array<ConfigBackup> ]
    def config_backups(opts = {})
      @config_backups ||= Finders::ConfigBackups::Base.find(self, opts)
    end

    # @param [ Hash ] opts
    #
    # @return [ Array<Media> ]
    def medias(opts = {})
      @medias ||= Finders::Medias::Base.find(self, opts)
    end

    # @param [ Hash ] opts
    #
    # @return [ Array<User> ]
    def users(opts = {})
      @users ||= Finders::Users::Base.find(self, opts)
    end
  end
end
