class sys_admin::xinetd() {
  #rsh/rlogin enable in securetty
  file_line { 'enable rsh':
    ensure => present,
    line   => 'rsh',
    path   => '/etc/securetty',
  }
  file_line { 'enable rlogin':
    ensure => present,
    line   => 'rlogin',
    path   => '/etc/securetty',
  }

  #rsh/rlogin enable in xinetd
  file_line { 'rsh enable':
    ensure  => present,
    path    => '/etc/xinetd.d/rsh',
    line    => '	disable                 = no',
    match   => '^[\t]disable[\s\t]*= [a-z]+',
    require => Package['rsh', 'rsh-server'],
  }
  file_line { 'rlogin enable':
    ensure  => present,
    path    => '/etc/xinetd.d/rlogin',
    line    => '	disable                 = no',
    match   => '^[\t]disable[\s\t]*= [a-z]+',
    require => Package['rsh', 'rsh-server'],
  }
  file { '/root/.rhosts':
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => 'puppet:///modules/sys_admin/rhosts',
  }

  #enable softwareonera
  if ($::lsbmajdistrelease == '5') and ($::host_group != 'servers') {
    file_line { 'softwareonera tcp':
      ensure => present,
      path   => '/etc/services',
      line   => 'softwareonera        3000/tcp                # softwareone Run time agent',
    }

    file_line { 'xinetd.conf instances':
      ensure => present,
      path   => '/etc/xinetd.conf',
      line   => '       instances       = UNLIMITED',
      match  => "^[\s\t]*instances[\s\t]*= [A-Z0-9]+",
      notify => Service['xinetd'],
    }
    file_line { 'xinetd.conf sources':
      ensure => present,
      path   => '/etc/xinetd.conf',
      line   => '       per_source      = UNLIMITED',
      match  => "^[\s\t]*per_source[\s\t]*= [A-Z0-9]+",
      notify => Service['xinetd'],
    }
  }

  #keep xinetd running and refresh when necessary
  service { 'xinetd':
    ensure    => running,
    enable    => true,
    subscribe => File_line['rsh enable', 'rlogin enable']
  }
}
