# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rcompile/version'

Gem::Specification.new do |spec|
  spec.name          = "rcompile"
  spec.version       = RCompile::VERSION
  spec.authors       = ["Mikael Henriksson"]
  spec.email         = ["mikael@zoolutions.se"]
  spec.summary       = %q{This gem contains a little helper to compile an entire rails app into pure html/css}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/mhenrixon/rcompile"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('methadone', '~> 1.3.1')
  spec.add_dependency('nokogiri')
  spec.add_dependency('sass')

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rdoc'
  spec.add_development_dependency 'rspec'
end
