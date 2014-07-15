require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require "rake/extensiontask"

RSpec::Core::RakeTask.new('spec')
Rake::ExtensionTask.new "seqtk_bindings"

task :spec => :compile
task :default => :spec
