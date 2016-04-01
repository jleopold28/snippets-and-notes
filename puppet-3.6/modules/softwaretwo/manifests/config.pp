class softwaretwo::config() {
  #establish ldconf files for softwaretwo
  define ldconfs($ldconf_file, $ldconf_present)
  {
    file { "/etc/ld.so.conf.d/$ldconf_file":
      ensure => $ldconf_present,
      mode   => '0644',
      source => "puppet:///modules/softwaretwo/$ldconf_file",
      owner  => root,
      group  => root,
    }
    exec { "ldconfig_$ldconf_file":
      command     => '/sbin/ldconfig',
      subscribe   => File["/etc/ld.so.conf.d/$ldconf_file"],
      refreshonly => true,
    }
  }

  $softwaretwo_ldconfs = {
    'sge'         => { ldconf_file    => 'sge.conf',
                       ldconf_present => present,
    },
    'softwaretwo' => { ldconf_file    => 'softwaretwo.conf',
                       ldconf_present => present,
    },
  }

  create_resources(ldconfs, $softwaretwo_ldconfs)

  #establish default profile environment for softwaretwo
  define envs($env_file, $env_present)
  {
    file { "/etc/profile.d/$env_file":
      ensure => $env_present,
      source => "puppet:///modules/softwaretwo/$env_file",
      owner  => root,
      group  => root,
    }
    exec { "profile_$env_file":
      command     => "/bin/bash -c 'source /etc/profile.d/$env_file'",
      subscribe   => File["/etc/profile.d/$env_file"],
      refreshonly => true,
    }
  }

  $softwaretwo_envs = {
    'sge'         => { env_file    => 'sge.sh',
                       env_present => present,
    },
    'softwaretwo' => { env_file    => 'softwaretwo.sh',
                       env_present => present,
    },
  }

  create_resources(envs, $softwaretwo_envs)

  #omniORB config file
  file { '/etc/omniORB.cfg':
    owner   => root,
    group   => softwaretwo,
    mode    => '0664',
    source  => 'puppet:///modules/softwaretwo/omniORB.cfg',
    require => Class['softwaretwo::install'],#devel or non-devel omniORB
  }

  #prevent mesaGL from obstructing proper OpenGL links (resets on yum rpm-post macros; needed for softwaretwo because qmake links against mesaGL)
  file { '/usr/lib64/libGL.so':
    ensure => link,
    target => '/usr/lib64/nvidia/libGL.so',
    force  => true,
  }
  file { '/usr/lib64/libGL.so.1':
    ensure => link,
    target => '/usr/lib64/nvidia/libGL.so.1',
    force  => true,
  }

  #sge ports
  file_line { 'sge_qmaster tcp':
    ensure => present,
    line   => "sge_qmaster     6444/tcp                # Grid Engine Qmaster Service",
    path   => '/etc/services',
  }
  file_line { 'sge_qmaster udp':
    ensure => present,
    line   => "sge_qmaster     6444/udp                # Grid Engine Qmaster Service",
    path   => '/etc/services',
  }
  file_line { 'sge_execd tcp':
    ensure => present,
    line   => "sge_execd       6445/tcp                # Grid Engine Execution Service",
    path   => '/etc/services',
  }
  file_line { 'sge_execd udp':
    ensure => present,
    line   => "sge_execd       6445/udp                # Grid Engine Execution Service",
    path   => '/etc/services',
  }

  #mount sge
  if $::lsbmajdistrelease == '6' {
    file { '/opt/sge/default':
      ensure  => directory,
      owner   => root,
      group   => root,
      mode    => '0755',
      require => Class['softwaretwo::install'],#devel or non-devel gridengine
    }
    mount { '/opt/sge/default':
      ensure  => mounted,
      device  => 'grid.company.org:/opt/sge/default',
      fstype  => nfs,
      options => 'rw,intr,bg,noatime,nfsvers=3,rsize=65536,wsize=65536',
      atboot  => true,
      require => File['/opt/sge/default'],
      before  => Service['sge_execd.default'],
    }
  }

  #automated execd setup; still under dev/testing
  if false {
  if $::host_group == 'nodes' {
    file { '/etc/init.d/sge_execd.default':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0754',
      source  => 'puppet:///modules/softwaretwo/sge_execd.default',
      require => Package['gridengine-execd'],
    }

    service { 'sge_execd.default':
      ensure    => running,
      enable    => true,
      subscribe => File['/etc/init.d/sge_execd.default', '/etc/profile.d/sge.sh'],
      require   => File_line['sge_qmaster tcp', 'sge_qmaster udp', 'sge_execd tcp', 'sge_execd udp'],
    }
  }
  }
}
