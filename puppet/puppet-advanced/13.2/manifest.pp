file { '/etc/foobar':
  ensure => present,
  audit  => 'all',
}
