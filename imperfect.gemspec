# -*- encoding: utf-8 -*-
require File.expand_path('../lib/imperfect/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Matt Colyer"]
  gem.email         = ["matt@easel.io"]
  gem.description   = %q{A simple way to track and alert on expected errors}
  gem.summary       = %q{A simple way to track and alert on expected errors}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "imperfect"
  gem.require_paths = ["lib"]
  gem.version       = Imperfect::VERSION

  gem.add_runtime_dependency "aws-sdk", "~> 1.7.1"
  gem.add_runtime_dependency "pagerduty", "~> 1.3.2"

  gem.add_development_dependency "bundler", "~> 1.2.0"
  gem.add_development_dependency "rspec", "~> 2.12.0"
  gem.add_development_dependency "guard-rspec", "~> 2.3.1"
  gem.add_development_dependency "listen", "~> 0.6.0"
  gem.add_development_dependency "rb-fsevent", "~> 0.9.1"
  gem.add_development_dependency "vcr", "~> 2.3.0"
  gem.add_development_dependency "webmock", "~> 1.9.0"
end
