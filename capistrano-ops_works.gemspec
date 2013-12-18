# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/ops_works/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-ops_works"
  spec.version       = Capistrano::OpsWorks::VERSION
  spec.authors       = ["Hubert Liu"]
  spec.email         = ["hubert.c.liu@gmail.com"]
  spec.description   = %q{AWS OpsWorks deployment with capistrano}
  spec.summary       = %q{Providing simple tasks to deploy to AWS OpsWorks using capistrano 3}
  spec.homepage      = "https://github.com/hcliu/capistrano-ops_works"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "aws"
end
