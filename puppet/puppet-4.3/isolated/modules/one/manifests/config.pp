class one::config {
  $return = hiera_array('one::return')
  exec { '/bin/ksh /script.ksh':
    user        => user1,
    subscribe   => Package['package'],
    refreshonly => true,
    require     => User['user1'],
    returns     => $return,
  }

  #lookup("${module_name}::one::dataload_array", Array[String], 'unique').each |$dataload| {
  hiera_array("${module_name}::one::dataload_array").each |$dataload| {
    custom::dataload { $dataload: dataload => $dataload }
  }

  ['/var', '/var/opt', '/var/opt/foo', '/etc', '/etc/opt', '/etc/opt/foo'].each |$dir| {
    file { "/opt/foo/bar${dir}":
      ensure  => directory,
      owner   => user2,
      group   => the_group,
      mode    => '0755',
      require => [User['user2'], Group['the_group']],
    }
  }
  ['/var/opt/foo', '/etc/opt/foo'].each |$dir| {
    file { $dir:
      ensure  => link,
      target  => "/opt/foo/bar${dir}",
      require => File["/opt/foo/bar${dir}"],
      before  => Package['package'],
    }
  }

  range('0', '50').each |$port| {
    if $port < 10 {
      $tcp_port = "0${port}"
    }
    else {
      $tcp_port = $port
    }
    file_line { "data${port} port${port}":
      ensure => present,
      path   => '/etc/services',
      line   => "data${port}  250${tcp_port}/tcp",
    }
  }

  $proxy_rand_int = fqdn_rand_string(1, '13579', '42')
  #$ssl_suffix = lookup('ssl_suffix', String, 'first')
  $ssl_suffix = hiera('ssl_suffix')
  file { "/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT-${ssl_suffix}":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => "puppet:///modules/${module_name}/RHN-ORG-TRUSTED-SSL-CERT-${ssl_suffix}",
    require => Package['yum-rhn-plugin'],
  }
}
