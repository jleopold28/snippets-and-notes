# manages puppet bindings with vault via hiera5 and custom functions
class vault_binding {
  package { 'vault':
    ensure          => latest,
    install_options => ['--no-document'],
    provider        => puppet_gem,
  }

  # TODO
  file { '/etc/puppetlabs/puppet/vault.yaml':
    ensure => file,
    source => "puppet:///modules/${module_name}/vault.yaml",
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0644',
  }
}
