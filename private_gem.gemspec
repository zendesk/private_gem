# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'private_gem/version'

Gem::Specification.new do |spec|
  spec.name          = 'private_gem'
  spec.version       = PrivateGem::VERSION
  spec.authors       = ['Mick Staugaard']
  spec.email         = ['mick@staugaard.com']
  spec.summary       = 'Tries to help you make sure your private gems stay private'
  # spec.description   = ''
  spec.homepage      = 'https://github.com/zendesk/private_gem'
  spec.license       = 'PRIVATE'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler', '~> 1.7'
  spec.add_dependency 'rake', '~> 10.0'
end
