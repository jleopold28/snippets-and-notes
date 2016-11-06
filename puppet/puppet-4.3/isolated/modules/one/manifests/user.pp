class one::user {
  #$user1_password = lookup('user1_password', String, 'first')
  $user1_password = hiera('user1_password')
  user { 'user1':
    ensure     => present,
    uid        => 1111,
    gid        => 111,
    password   => $user1_password,
    home       => '/home/user1',
    managehome => true,
    shell      => '/usr/bin/zsh',
    comment    => 'Comment',
  }

  ['ldap1', 'ldap2', 'ldap3'].each |$ldif| { custom::ldap { $ldif: ldif => $ldif } }

  ['script1', 'script2', 'script3', 'script4'].each |$script| { custom::script { $script: script => "${script}.zsh" } }

  user { 'user2':
    ensure    => present,
    uid       => 2222,
    allowdupe => true,
    groups    => thegroup,
    password  => $one::user::user2_password,
    home      => '/home/user2',
    shell     => '/usr/bin/ksh',
    comment   => 'Another Comment',
    require   => Group['the_group'],
  }
}
