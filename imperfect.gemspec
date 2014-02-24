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

  gem.add_runtime_dependency "aws-sdk", "~> 1.34"

  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rspec", "~> 2.14"
  gem.add_development_dependency "guard-rspec", "~> 4.2"
  gem.add_development_dependency "listen", "~> 2.5"
  gem.add_development_dependency "rb-fsevent", "~> 0.9.4"
  gem.add_development_dependency "vcr", "~> 2.8"
  gem.add_development_dependency "webmock", "~> 1.16"
end
