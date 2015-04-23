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

      vulns << rce_webshot_vuln if version == false || version > '1.35' && version < '2.8.14'
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
        { url: ['http://seclists.org/fulldisclosure/2014/Jun/117'] },
        'RCE',
        '2.8.14'
      )
    end
  end
end
