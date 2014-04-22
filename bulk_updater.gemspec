# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bulk_updater/version'

Gem::Specification.new do |spec|
  spec.name          = "bulk_updater"
  spec.version       = BulkUpdater::VERSION
  spec.authors       = ["Alex Teut"]
  spec.email         = ["jaturken@gmail.com"]
  spec.summary       = %q{Generate and execute SQL UPDATE for bulk updating multiple records by one request.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end