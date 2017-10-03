Gem::Specification.new do |spec|
  spec.name          = 'secure'
  spec.version       = '0.0.2'
  spec.authors       = ['Matt Schuchard']
  spec.description   = 'Ad-hoc encrypt and decrypt data via OpenSSL and GPG.'
  spec.summary       = 'Ad-hoc encrypt and decrypt data.'
  spec.homepage      = 'https://www.github.com/mschuchard/snippets-and-notes/secure'
  spec.license       = 'Proprietary'

  spec.files         = Dir['bin/**/*', 'lib/**/*', 'spec/**/*', 'README.md']
  spec.executables   = spec.files.grep(%r{^bin/}) { |file| File.basename(file) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = Dir['lib']

  spec.required_ruby_version = '>= 2.0.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
