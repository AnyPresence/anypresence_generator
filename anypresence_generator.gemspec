# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'anypresence_generator/version'

Gem::Specification.new do |spec|
  spec.name          = "anypresence_generator"
  spec.version       = AnypresenceGenerator::VERSION
  spec.authors       = ["AnyPresence, Inc."]
  spec.email         = ["jbozek@anypresence.com"]
  spec.summary       = %q{Base gem used for interaction between AP generators and the core designer.}
  spec.homepage      = "http://www.anypresence.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "yajl-ruby", "~> 1.2.0"
  spec.add_runtime_dependency "rest-client", "~> 1.6.7"
  spec.add_runtime_dependency "git", "~> 1.2.6"
  spec.add_runtime_dependency "recursive-open-struct", "0.4.5"
  spec.add_runtime_dependency "fast_blank", "~> 0.0.2"
  spec.add_runtime_dependency "jsonpath", "~> 0.5.6"
  spec.add_runtime_dependency "bundler", "~> 1.5"
end
