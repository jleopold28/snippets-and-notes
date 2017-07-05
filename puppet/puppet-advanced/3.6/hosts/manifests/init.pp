class hosts {
  @@host { $facts['fqdn']: ensure => present }
}
