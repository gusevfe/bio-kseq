# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bioruby/seqtk/version'

Gem::Specification.new do |spec|
  spec.name          = "bioruby-seqtk"
  spec.version       = Bioruby::Seqtk::VERSION
  spec.authors       = ["Gusev Fedor"]
  spec.email         = ["gusevfe@gmail.com"]
  spec.summary       = %q{Ruby inferface for SeqTK}
  spec.description   = %q{A fast FASTA/FASTQ parser based on SeqTK library by Heng Li}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.extensions    << "ext/seqtk_bindings/extconf.rb"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
