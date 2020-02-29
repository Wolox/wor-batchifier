# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wor/batchifier/version'
require 'date'

Gem::Specification.new do |spec|
  spec.name          = 'wor-batchifier'
  spec.version       = Wor::Batchifier::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.date          = Date.today
  spec.authors       = ['enanodr', 'redwarewolf']
  spec.email         = ['diego.raffo@wolox.com.ar', 'pedro.jara@wolox.com.ar']

  spec.summary       = 'Easily batchify your requests!.'
  spec.description   = 'Gem to batchify your requests.'
  spec.homepage      = 'https://github.com/Wolox/wor-batchifier'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec)/}) }
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty', '~> 0.13'

  spec.add_development_dependency 'byebug', '~> 9.0'
  spec.add_development_dependency 'rubocop', '~> 0.47'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'webmock'
end
