# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wpscan/version'

Gem::Specification.new do |s|
  s.name                  = 'wpscan'
  s.version               = WPScan::VERSION
  s.platform              = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.1.0'
  s.authors               = ['WPScanTeam']
  s.date                  = Time.now.utc.strftime('%Y-%m-%d')
  s.email                 = ['team@wpscan.org']
  s.summary               = 'WPScan Gem - Experimental'
  s.description           = 'Future version of WPScan'
  s.homepage              = 'http://wpscan.org/'
  s.license               = 'Dual'

  s.files                 = `git ls-files -z`.split("\x0").reject do |file|
    file =~ %r{^(?:
      spec\/.*
      |Gemfile
      |Rakefile
      |\.rspec
      |\.gitignore
      |\.rubocop.yml
      |\.travis.yml
      |\.ruby-gemset
      |\.ruby-version
      )$}x
  end
  s.test_files            = []
  s.executables           = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_path          = 'lib'

  s.add_dependency 'yajl-ruby', '~> 1.2.1' # Better JSON parser regarding memory usage
  s.add_dependency 'cms_scanner', '~> 0.0.37.1'
  s.add_dependency 'activesupport', '~> 4.2' # Not sure if needed there as already needed in the CMSScanner
  # DB dependencies
  s.add_dependency 'dm-core', '~> 1.2'
  s.add_dependency 'dm-migrations', '~> 1.2'
  s.add_dependency 'dm-constraints', '~> 1.2'
  s.add_dependency 'dm-sqlite-adapter', '~> 1.2'

  s.add_development_dependency 'rake', '~> 10.4'
  s.add_development_dependency 'rspec', '~> 3.3'
  s.add_development_dependency 'rspec-its', '~> 1.2'
  s.add_development_dependency 'bundler', '~> 1.6'
  s.add_development_dependency 'rubocop', '~> 0.34'
  s.add_development_dependency 'webmock', '~> 1.22'
  s.add_development_dependency 'simplecov', '~> 0.10'
end
