module WPScan
  # WpItem (superclass of Plugin & Theme)
  class WpItem
    include Vulnerable
    include Finders::Finding
    include CMSScanner::Target::Platform::PHP
    include CMSScanner::Target::Server::Generic

    READMES    = %w(readme.txt README.txt Readme.txt ReadMe.txt README.TXT readme.TXT).freeze
    CHANGELOGS = %w(changelog.txt Changelog.txt ChangeLog.txt CHANGELOG.txt).freeze

    attr_reader :uri, :name, :detection_opts, :target, :db_data

    # @param [ String ] name The plugin/theme name
    # @param [ Target ] target The targeted blog
    # @param [ Hash ] opts
    # @option opts [ String ] :detection_mode
    # @option opts [ Boolean ] :version_all Wether or not to
    # @option opts [ String ] :url The URL of the item
    def initialize(name, target, opts = {})
      @name           = URI.decode(name)
      @target         = target
      @uri            = Addressable::URI.parse(opts[:url]) if opts[:url]

      # Options used to detect the version
      @detection_opts = { mode: opts[:mode], confidence_threshold: opts[:version_all] ? 0 : 100 }

      parse_finding_options(opts)
    end

    # @return [ Array<Vulnerabily> ]
    def vulnerabilities
      return @vulnerabilities if @vulnerabilities

      @vulnerabilities = []

      [*db_data['vulnerabilities']].each do |json_vuln|
        vulnerability = Vulnerability.load_from_json(json_vuln)
        @vulnerabilities << vulnerability if vulnerable_to?(vulnerability)
      end

      @vulnerabilities
    end

    # Checks if the wp_item is vulnerable to a specific vulnerability
    #
    # @param [ Vulnerability ] vuln Vulnerability to check the item against
    #
    # @return [ Boolean ]
    def vulnerable_to?(vuln)
      return true unless version && vuln && vuln.fixed_in && !vuln.fixed_in.empty?

      version < vuln.fixed_in ? true : false
    end

    # @return [ String ]
    def latest_version
      @latest_version ||= db_data['latest_version']
    end

    # Not used anywhere ATM
    # @return [ Boolean ]
    def popular?
      @popular ||= db_data['popular']
    end

    # URI.encode is preferered over Addressable::URI.encode as it will encode
    # leading # character:
    # URI.encode('#t#') => %23t%23
    # Addressable::URI.encode('#t#') => #t%23
    #
    # @param [ String ] path Optional path to merge with the uri
    #
    # @return [ String ]
    def url(path = nil)
      return unless @uri
      return @uri.to_s unless path

      @uri.join(URI.encode(path)).to_s
    end

    # @return [ Boolean ]
    def ==(other)
      return false unless self.class == other.class

      name == other.name
    end

    def to_s
      name
    end

    # @return [ Symbol ] The Class name associated to the item name
    def classify_name
      name.to_s.tr('-', '_').camelize.to_s.to_sym
    end

    # @return [ String ] The readme url if found
    def readme_url
      return if detection_opts[:mode] == :passive

      if @readme_url.nil?
        READMES.each do |path|
          return @readme_url = url(path) if Browser.get(url(path)).code == 200
        end
      end

      @readme_url
    end

    # @return [ String, false ] The changelog urr if found
    def changelog_url
      return if detection_opts[:mode] == :passive

      if @changelog_url.nil?
        CHANGELOGS.each do |path|
          return @changelog_url = url(path) if Browser.get(url(path)).code == 200
        end
      end

      @changelog_url
    end

    # @param [ String ] path
    # @param [ Hash ] params The request params
    #
    # @return [ Boolean ]
    def directory_listing?(path = nil, params = {})
      return if detection_opts[:mode] == :passive
      super(path, params)
    end

    # @param [ String ] path
    # @param [ Hash ] params The request params
    #
    # @return [ Boolean ]
    def error_log?(path = 'error_log', params = {})
      return if detection_opts[:mode] == :passive
      super(path, params)
    end
  end
end
