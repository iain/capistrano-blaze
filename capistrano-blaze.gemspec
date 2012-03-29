# -*- encoding: utf-8 -*-
require File.expand_path('../lib/capistrano/blaze/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["iain"]
  gem.email         = ["iain@iain.nl"]
  gem.description   = %q{A simple campfire plugin for capistrano}
  gem.summary       = %q{A simple campfire plugin for capistrano}
  gem.homepage      = "https://github.com/iain/capistrano-blaze"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "capistrano-blaze"
  gem.require_paths = ["lib"]
  gem.version       = Capistrano::Blaze::VERSION

  gem.add_development_dependency "rspec", "~> 2.9"
  gem.add_development_dependency "webmock", "~> 1.8.4"
end
