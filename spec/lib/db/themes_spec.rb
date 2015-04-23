require 'spec_helper'

describe WPScan::DB::Themes do
  subject(:themes) { described_class }

  describe '#vulnerable_names' do
    its(:vulnerable_names) do
      should eql %w(dignitas-themes yaaburnee-themes)
    end
  end
end
