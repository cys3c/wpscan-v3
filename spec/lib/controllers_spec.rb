require 'spec_helper'

describe WPScan::Controllers do
  subject(:formatters) { described_class.new }

  describe '#option_parser' do
    it 'returns the 4 correct path to look for config files' do
      expected = []

      [Dir.home, Dir.pwd].each do |dir|
        %w(json yml).each do |ext|
          expected << File.join(dir, '.wpscan', "config.#{ext}")
        end
      end

      expect(formatters.option_parser.options_files).to eql expected
    end
  end
end
