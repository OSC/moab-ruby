# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'moab/version'

Gem::Specification.new do |spec|
  spec.name          = "moab"
  spec.version       = Moab::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Jeremy Nicklas"]
  spec.email         = ["jnicklas@osc.edu"]
  spec.summary       = %q{Very basic ruby gem that interfaces with Adaptive Computing's scheduler Moab}
  spec.description   = %q{Ruby wrapper for the Moab binaries. It uses the XML output of Moab for easy parsing.}
  spec.homepage      = "https://github.com/OSC/moab-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.2.0"

  spec.add_runtime_dependency "nokogiri", "~> 1.0"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
