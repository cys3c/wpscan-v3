require 'bundler/gem_tasks'

exec = []

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  exec << :spec
rescue LoadError
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
  exec << :rubocop
rescue LoadError
end

# Run rubocop & rspec before the build (only if installed)
task build: exec

