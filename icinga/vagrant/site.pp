node 'master.vagrant.test' {
  class { 'icinga':
    master         => true,
    icinga_version => '2.5.4',
  }
}

node default {
  class { 'icinga':
    master         => false,
    icinga_version => '2.5.4',
  }
}
