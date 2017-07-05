package {
  default: ensure => latest
  ;
  ['glibc', 'git']:
}

file {
  default:
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  ;
  '/etc/userfoo':
  ;
  '/etc/groupfoo':
  ;
  '/etc/userbar': owner => 'vagrant'
  ;
  '/etc/groupbar': mode => '0466'
  ;
}

###

$file_defaults = {
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
}

file {
  default: * => $file_defaults
  ;
  '/etc/userfoo':
  ;
  '/etc/groupfoo':
  ;
  '/etc/userbar': owner => 'vagrant'
  ;
  '/etc/groupbar': mode => '0466'
  ;
}

###

Resource[Package] {
  default: ensure => latest
  ;
  ['glibc', 'git']:
}

###

File['/etc/userfoo'] { content => 'userfoo' }
File['/etc/group'] { content => 'groupfoo' }
