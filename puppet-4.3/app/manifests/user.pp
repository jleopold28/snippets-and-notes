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

  ['ldap_one', 'ldap_two', 'ldap_three'].each |$ldap_conf| {
    custom::ldap { $ldap_conf: ldap_conf => $ldap_conf }
  }
}
