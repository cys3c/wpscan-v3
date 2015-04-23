require 'spec_helper'

describe WPScan::Finders::Users::LoginErrorMessages do
  subject(:finder) { described_class.new(target) }
  let(:target)     { WPScan::Target.new(url) }
  let(:url)        { 'http://wp.lab/' }
  let(:fixtures)   { File.join(FINDERS_FIXTURES, 'users', 'login_error_messages') }

  describe '#aggressive' do
    xit
  end
end
