# Time calculations based on ActiveSupport http://www.rubydoc.info/gems/activesupport/4.2.4/Numeric
# the active_support/core_ext/object can't be directly required as it screw up JSON stuff
class Fixnum
  SECONDS_IN_DAY = 24 * 60 * 60

  def days
    self * SECONDS_IN_DAY
  end

  def ago
    Time.now - self
  end
end
