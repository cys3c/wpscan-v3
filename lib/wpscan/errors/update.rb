module WPScan
  # Error raised when no DB files present and --no-update supplied
  class NoDatabase < StandardError
    def to_s
      'Update required, you can not run a scan without any databases.'
    end
  end
end
