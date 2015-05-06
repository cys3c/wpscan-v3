# Gems
require 'cms_scanner'
require 'addressable/uri'
# Standard Lib
require 'uri'
require 'securerandom'
# Custom Libs
require 'wpscan/helper'
require 'wpscan/db'
require 'wpscan/version'
require 'wpscan/errors/wordpress'
require 'wpscan/errors/http'
require 'wpscan/browser'
require 'wpscan/target'
require 'wpscan/finders'
require 'wpscan/formatter'
require 'wpscan/controller'
require 'wpscan/controllers'
require 'wpscan/vulnerability'

Encoding.default_external = Encoding::UTF_8

# WPScan
module WPScan
  include CMSScanner

  APP_DIR = Pathname.new(__FILE__).dirname.join('..', 'app').expand_path
  DB_DIR  = File.join(Dir.home, '.wpscan', 'db')
end

require "#{WPScan::APP_DIR}/app"
