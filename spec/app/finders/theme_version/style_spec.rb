require 'spec_helper'

describe WPScan::Finders::ThemeVersion::Style do
  subject(:finder) { described_class.new(theme) }
  let(:theme)      { WPScan::Theme.new('spec', target) }
  let(:target)     { WPScan::Target.new('http://wp.lab/') }
  let(:fixtures)   { File.join(FINDERS_FIXTURES, 'theme_version', 'style') }

  xit
end
