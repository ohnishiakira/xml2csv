# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xml2csv/version'

Gem::Specification.new do |spec|
  spec.name          = "xml2csv"
  spec.version       = XML2CSV::VERSION
  spec.authors       = ["Akira Ohnishi"]
  spec.email         = ["s06206ao@gmail.com"]
  spec.summary       = %q{Convert XML to CSV.}
  spec.description   = %q{Convert XML to CSV. Written in Ruby.}
  spec.homepage      = "https://github.com/ohnishiakira/xml2csv"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", "~> 4.0"
  spec.add_runtime_dependency "nokogiri", "~> 1.6"
  spec.add_runtime_dependency "slop", "~> 3.4"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 0"
end
