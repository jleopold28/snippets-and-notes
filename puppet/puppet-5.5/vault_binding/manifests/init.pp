# manages puppet bindings with vault via hiera5 and custom functions
class vault_binding {
  # restrict to master
  if $servername == $facts['networking']['fqdn'] {
    # vault ruby bindings
    package { 'vault':
      ensure          => latest,
      install_options => ['--no-document'],
      provider        => puppet_gem,
    }

    # vault config file for ruby bindings
    file { '/etc/puppetlabs/puppet/vault.yaml':
      ensure => file,
      source => "puppet:///modules/${module_name}/vault.yaml",
      owner  => 'pe-puppet',
      group  => 'pe-puppet',
      mode   => '0644',
    }
  }
}
