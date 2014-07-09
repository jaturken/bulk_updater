# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "bulk_updater"
  spec.version       = '0.0.1'
  spec.author        = "Alex Teut"
  spec.email         = ["jaturken@gmail.com"]
  spec.summary       = %q{Generate and execute SQL UPDATE for bulk updating multiple records by one request.}
  spec.description   = %q{Gem for joining multiple UPDATE requests into one. Useful when you regular update multiple record.}
  spec.homepage      = "https://github.com/jaturken/bulk_updater"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", '>= 0'
  spec.add_runtime_dependency 'activerecord', '>= 0'
end
