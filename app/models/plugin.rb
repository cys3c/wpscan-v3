module WPScan
  # WordPress Plugin
  class Plugin < WpItem
    # See WpItem
    def initialize(name, target, opts = {})
      super(name, target, opts)

      @uri = Addressable::URI.parse(target.url("wp-content/plugins/#{name}/"))
    end

    # @param [ Hash ] opts
    #
    # @return [ WPScan::Version, false ]
    def version(opts = {})
      @version = Finders::PluginVersion::Base.find(self, detection_opts.merge(opts)) if @version.nil?

      @version
    end

    # @return [ Array<Vulneraility> ]
    def vulnerabilities
      DB::Plugin.vulnerabilities(self)
    end
  end
end
