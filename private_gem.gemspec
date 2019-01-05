require './lib/private_gem/version'

Gem::Specification.new do |spec|
  spec.name          = 'private_gem'
  spec.version       = PrivateGem::VERSION
  spec.authors       = ['Mick Staugaard']
  spec.email         = ['mick@staugaard.com']
  spec.summary       = 'Keeps your private gems private'
  spec.homepage      = 'https://github.com/zendesk/private_gem'
  spec.license       = 'Apache License Version 2.0'

  spec.files         = Dir.glob('lib/**/*')
  spec.executables   = Dir.glob('bin/**/*').map {|f| File.basename(f)}

  spec.add_dependency 'bundler', '> 1.7', '< 3.0'
  spec.add_dependency 'thor'

  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'minitest-around'
  spec.add_development_dependency 'bump'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'byebug'

  spec.required_ruby_version = '>= 2.3' # keep in sync with .travis.yml
end
