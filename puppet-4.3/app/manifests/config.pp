class app::config() {
  file { '/foo.jar':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0777',
    source => "puppet:///modules/${module_name}/foo.jar",
  }

  exec { "/bin/zsh -c 'source /env_script; /bin/aaa arg; /bin/bbb arg arg; /bin/ccc arg'": user => datauser }

  file { '/foo':
    ensure => absent,
    force  => true,
  }

  custom::script { 'updates.ksh':
    script    => 'updates.ksh',
    exec_attr => { environment => 'TMP=/tmp' },
  }

  file { '/conf/foo':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => "foo\nbar",
  }
  file { ['/dir1', '/dir2', '/dir3']:
    ensure => directory,
    mode   => '0777',
    owner  => app_user,
    group  => app_user,
  }
  file { '/text/file':
    ensure  => file,
    owner   => app_user,
    group   => app_user,
    mode    => '0777',
    content => "foo\nbar",
    require => File['/dir2'],
  }

  $version = hiera('app::version')
  file { '/tmp/update_version.zsh':
    ensure  => file,
    content => template("${module_name}/update_version.erb"),
    owner   => root,
    group   => root,
    mode    => '0754',
  }
  exec { '/bin/zsh /tmp/update_version.zsh':
    subscribe   => File['/tmp/update_version.zsh'],
    refreshonly => true,
  }

  exec { '/usr/bin/curl -s http://localhost:12345/app/service?start':
    subscribe   => Exec['/bin/zsh /tmp/update_version.zsh'],
    refreshonly => true,
  }

  file { ['/tmp/one', '/tmp/two', '/tmp/three']:
    ensure => absent,
    force  => true,
  }
}
