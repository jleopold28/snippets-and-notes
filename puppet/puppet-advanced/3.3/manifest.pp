@user { 'alice':
  ensure => present,
  tag    => 'networking',
}

@user { 'bob':
  ensure => present,
  tag    => 'database',
}

@user { 'cary':
  ensure => present,
  tag    => 'sysadmin',
}

@user { 'linus': ensure => present }

User <| tag == 'database' |>
realize(User['linus'])
