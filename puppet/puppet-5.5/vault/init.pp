package { ['vault', 'hiera-vault']:
  ensure          => latest,
  install_options => ['--no-document'],
  provider        => puppetserver_gem,
}

# finish
file { '/etc/puppetlabs/puppet/vault.yaml':
  ensure => file,
  source => "puppet:///modules/${module_name}/vault.yaml",
}
