class sys_admin::config() {
  #configure hosts file for pvm and sge
  file_line { 'local host entry':
    ensure => present,
    line   => "$::ipaddress_eth0 $::fqdn $::hostname",
    path   => '/etc/hosts',
  }

  #configure ntp
  service { 'ntpd':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/ntp.conf'],
  }

  file { '/etc/ntp.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    source  => "puppet:///modules/sys_admin/rhel${::lsbmajdistrelease}_ntp.conf",
    mode    => '0644',
    require => Package['ntp'],
  }

  #maintain sudoers: more elegant but untested yet method
#  define sudoers_lines($sudo_line, $sudo_present, $sudo_match, $sudo_after)
#  {
#    file_line { "place $sudo_line in sudoers":
#      ensure => "$sudo_present",
#      path => '/etc/sudoers',
#      line => "$sudo_line",
#      after => "$sudo_after",
#      match => "$sudo_match"
#    }
#  }

#  $sudo_lines = {
#    'localhost' => { sudo_line => "Host_Alias      LOCALHOST = $ipaddress",
#                     sudo_present => present,
#                     sudo_match => '.*',
#                     after => '# Host_Alias     MAILSERVERS = smtp, smtp2',
#                   },
#    'useralias' => {
#  }

#  if $host_group != 'servers' {
#    create_resources(sudoers_lines, $sudo_lines)
#  }

  #maintain sudoers: uglier yet effective method
  file_line { 'establish localhost in sudoers':
    ensure => present,
    path   => '/etc/sudoers',
    line   => "Host_Alias      LOCALHOST = $::ipaddress",
    after  => '# Host_Alias     MAILSERVERS = smtp, smtp2',
  }
  file_line { 'establish useralias in sudoers':
    ensure => present,
    path   => '/etc/sudoers',
    line   => 'User_Alias softwaretwo = jhurt3, ec113, bp51, ch302, roneill6, jadams39, softwaretwo',
    after  => '# User_Alias ADMINS = jsmith, mikem',
  }
  file_line { 'uncomment services permissions in sudoers':
    ensure => present,
    path   => '/etc/sudoers',
    line   => 'Cmnd_Alias SERVICES = /sbin/service, /sbin/chkconfig',
    match  => '^.*Cmnd_Alias SERVICES = /sbin/service, /sbin/chkconfig',
  }
  file_line { 'uncomment processes permissions in sudoers':
    ensure => present,
    path   => '/etc/sudoers',
    line   => 'Cmnd_Alias PROCESSES = /bin/nice, /bin/kill, /usr/bin/kill, /usr/bin/killall',
    match  => '^.*Cmnd_Alias PROCESSES = /bin/nice, /bin/kill, /usr/bin/kill, /usr/bin/killall',
  }
  file_line { 'set local scope softwaretwo group sudo permissions':
    ensure => present,
    path   => '/etc/sudoers',
    line   => 'softwaretwo     LOCALHOST = SERVICES, PROCESSES, /bin/chown',
    after  => 'root	ALL=\(ALL\) 	ALL',
  }

  #permissive selinux
  file_line { 'permissive selinux':
    ensure => present,
    path   => '/etc/sysconfig/selinux',
    line   => 'SELINUX=permissive',
    match  => '^SELINUX=[a-z]+',
  }
  #disable firewalls
  service { 'iptables':
    ensure => stopped,
    enable => false,
  }
  service { 'ip6tables':
    ensure => stopped,
    enable => false,
  }
}
