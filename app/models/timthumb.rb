module WPScan
  # Timthumb
  class Timthumb < CMSScanner::InterestingFinding
    include Vulnerable

    # Opts used to detect the version
    attr_reader :detection_opts

    # @param [ String ] url
    # @param [ Hash ] opts
    # @option opts [ String ] :detection_mode
    def initialize(url, opts = {})
      super(url, opts)

      @detection_opts = { mode: opts[:mode] }
    end

    # @param [ Hash ] opts
    #
    # @return [ WPScan::Version, false ]
    def version(opts = {})
      if @version.nil?
        @version = Finders::TimthumbVersion::Base.find(self, detection_opts.merge(opts))
      end

      @version
    end

    # @return [ Array<Vulnerability> ]
    def vulnerabilities
      vulns = []

      vulns << rce_webshot_vuln if version == false || version > '1.35' && version < '2.8.14' && webshot_enabled?
      vulns << rce_132_vuln if version == false || version < '1.33'

      vulns
    end

    # @return [ Vulnerability ] The RCE in the <= 1.32
    def rce_132_vuln
      Vulnerability.new(
        'Timthumb <= 1.32 Remote Code Execution',
        { exploitdb: ['17602'] },
        'RCE',
        '1.33'
      )
    end

    # @return [ Vulnerability ] The RCE due to the WebShot in the > 1.35 (or >= 2.0) and <= 2.8.13
    def rce_webshot_vuln
      Vulnerability.new(
        'Timthumb <= 2.8.13 WebShot Remote Code Execution',
        {
          url: ['http://seclists.org/fulldisclosure/2014/Jun/117', 'https://github.com/wpscanteam/wpscan/issues/519'],
          cve: '2014-4663'
        },
        'RCE',
        '2.8.14'
      )
    end

    # @return [ Boolean ]
    def webshot_enabled?
      res = Browser.get(url, params: { webshot: 1, src: "http://#{default_allowed_domains.sample}" })

      res.body =~ /WEBSHOT_ENABLED == true/ ? false : true
    end

    # @return [ Array<String> ] The default allowed domains (between the 2.0 and 2.8.13)
    def default_allowed_domains
      %w(flickr.com picasa.com img.youtube.com upload.wikimedia.org)
    end
  end
end
