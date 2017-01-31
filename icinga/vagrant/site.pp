node 'master.vagrant.test' {
  class { 'icinga':
    master         => true,
    icinga_version => '2.5.4',
    master_fqdn    => 'master.vagrant.test',
  }
}

node /client/ {
  class { 'icinga':
    master         => false,
    icinga_version => '2.5.4',
    master_fqdn    => 'master.vagrant.test',
  }
}
