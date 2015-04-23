$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'simplecov'
require 'rspec/its'
require 'webmock/rspec'

if ENV['TRAVIS']
  require 'coveralls'
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
end

SimpleCov.start do
  add_filter '/spec/'
  add_filter 'helper'
end

# See http://betterspecs.org/
RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def redefine_constant(constant, value)
  WPScan.send(:remove_const, constant)
  WPScan.const_set(constant, value)
end

require 'wpscan'
require 'shared_examples'

SPECS            = Pathname.new(__FILE__).dirname.to_s
FIXTURES         = File.join(SPECS, 'fixtures')
FINDERS_FIXTURES = File.join(FIXTURES, 'finders')

redefine_constant(:DB_DIR, File.join(FIXTURES, 'db'))

WPScan::DB.init_db
