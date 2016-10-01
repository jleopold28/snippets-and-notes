class app::user() {
  if $facts['env'] == 'prod' {
    $app_password = '1234567890'
  }
  else {
    $app_password = '0987654321'
  }
  user { 'app_user':
    uid        => 111,
    gid        => 222,
    password   => $app_password,
    home       => '/home/app',
    managehome => true,
    shell      => '/usr/bin/zsh',
    comment    => 'awesomesauce',
  }
  file { '/home/app/.profile':
    ensure  => file,
    owner   => app,
    group   => users,
    mode    => '0644',
    source  => "puppet:///modules/${module_name}/profile",
    require => User['app'],
  }
  file { '/home/app/.shosts':
    ensure  => file,
    content => template("${module_name}/shosts.erb"),
    owner   => app,
    mode    => '0644',
    require => User['app'],
  }

  file { ['/home/user', '/home/user/.ssh']:
    ensure => directory,
    mode   => '0700',
  }
  if $facts['env'] == 'prod' {
    $user_rsa_env = $facts['env']
  }
  else {
    $user_rsa_env = 'qa'
  }
  file { '/home/user/.ssh/id_rsa':
    ensure  => file,
    source  => "puppet:///modules/${module_name}/id_rsa_${user_rsa_env}",
    owner   => user,
    group   => root,
    mode    => '0600',
    backup  => '.bak',
    require => File['/home/user/.ssh'],
  }

  ['ldap_one', 'ldap_two', 'ldap_three'].each |$ldap_conf| {
    custom::ldap { $ldap_conf: ldap_conf => $ldap_conf }
  }
}
