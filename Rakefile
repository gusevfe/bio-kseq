require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require "rake/extensiontask"

RSpec::Core::RakeTask.new('spec')

Rake::ExtensionTask.new "seqtk_bindings" do |ext|
  ext.lib_dir = "lib/seqtk_bindings"
end
