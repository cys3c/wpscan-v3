require 'spec_helper'

describe WPScan::DB::Plugins do
  subject(:plugins) { described_class }

  describe '#vulnerable_names' do
    its(:vulnerable_names) do
      should eql %w(no-vulns theme-my-login)
    end
  end
end
