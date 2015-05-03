module WPScan
  # Not WordPress Error
  class NotWordPressError < StandardError
    def to_s
      'The remote website is up, but does not seem to be running WordPress.'
    end
  end

  # Invalid Wp Version (used in the WpVersion#new)
  class InvalidWordPressVersion < StandardError
    def to_s
      'The WordPress version is invalid'
    end
  end
end
