Gem::Specification.new do |spec|
  spec.name          = 'zauber-automato'
  spec.version       = '1.0.0'
  spec.authors       = ['Matt Schuchard']
  spec.description   = 'Zauber Autômato is a gem that automatically generates Ansible task lists, Chef recipes, and Puppet manifests from your Serverspec tests. It is automatic TDD software for configuration management, orchestration, and automation.'
  spec.summary       = 'Automatic TDD from Serverspec to Ansible, Chef, and Puppet'
  spec.homepage      = 'https://www.github.com/mschuchard/zauber-automato'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*', 'spec/**/*', 'CHANGELOG.md', 'LICENSE.md', 'README.md']
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = Dir['lib']

  spec.required_ruby_version = '>= 2.0.0'
  spec.add_dependency 'rake', '>= 9', '< 13'
  spec.add_dependency 'rspec', '~> 3.0'
  spec.add_dependency 'rspec-its', '~> 1.2.0'
  spec.add_development_dependency 'rubocop', '~> 0'
  spec.add_development_dependency 'reek', '~> 4.0'
end
