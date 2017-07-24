class hosts {
  @@host { $facts['fqdn']:
    ensure => present,
    ip     => $facts['ipaddress'],
  }
}
