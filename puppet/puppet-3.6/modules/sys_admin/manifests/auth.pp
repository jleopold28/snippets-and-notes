class sys_admin::auth() {
  #create dir for cacerts
  file { '/etc/openldap/cacerts':
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0755',
  }

  #create cacerts
  file { '/etc/openldap/cacerts/cacert.asc_apatldepartmentdp01':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => 'puppet:///modules/sys_admin/cacert.asc_apatldepartmentdp01',
    require => File['/etc/openldap/cacerts'],
  }

  #rehash certs
  exec { '/usr/sbin/cacertdir_rehash /etc/openldap/cacerts':
    subscribe   => File['/etc/openldap/cacerts/cacert.asc_apatldepartmentdp01'],
    refreshonly => true,
  }

  file { '/etc/nsswitch.conf':
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => "puppet:///modules/sys_admin/rhel${::lsbmajdistrelease}_nsswitch.conf",
  }

  file { '/etc/sysconfig/authconfig':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
      source => "puppet:///modules/sys_admin/rhel${::lsbmajdistrelease}_authconfig",
  }

  if $::lsbmajdistrelease == '5' {
    file { '/etc/openldap/ldap.conf':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
      source => 'puppet:///modules/sys_admin/openldap_ldap.conf',
    }

    file { '/etc/ldap.conf':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
      source => 'puppet:///modules/sys_admin/etc_ldap.conf',
    }

    file { '/etc/nscd.conf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      source  => 'puppet:///modules/sys_admin/rhel5_ldap_nscd.conf',
      require => Package['nscd'],
    }

    file { '/etc/pam.d/system-auth-ac':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
      source => 'puppet:///modules/sys_admin/rhel5_system-auth-ac',
    }

    file { '/etc/pam.d/system-auth':
      ensure => link,
      target => '/etc/pam.d/system-auth-ac',
    }

    service { 'nscd':
      ensure    => running,
      enable    => true,
      subscribe => File['/etc/openldap/ldap.conf', '/etc/ldap.conf', '/etc/nsswitch.conf', '/etc/sysconfig/authconfig', '/etc/pam.d/system-auth-ac', '/etc/pam.d/system-auth'],
      before    => File['/etc/omniORB.cfg'] #softwaretwo group
    }
  }

  elsif $::lsbmajdistrelease == 6 {
    file { '/etc/sssd/sssd.conf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0600',
      source  => 'puppet:///modules/sys_admin/rhel6_sssd.conf',
      require => Package['sssd'],
    }

    file { '/etc/pam.d/system-auth-ac':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
      source => 'puppet:///modules/sys_admin/rhel6_system-auth-ac',
    }

    file { '/etc/pam.d/system-auth':
      ensure  => link,
      target  => '/etc/pam.d/system-auth-ac',
      require => File['/etc/pam.d/system-auth-ac'],
    }

    file { '/etc/pam.d/password-auth-ac':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
      source => 'puppet:///modules/sys_admin/rhel6_password-auth-ac',
    }

    file { '/etc/pam.d/password-auth':
      ensure  => link,
      target  => '/etc/pam.d/password-auth-ac',
      require => File['/etc/pam.d/password-auth-ac'],
    }

    service { 'sssd':
      ensure    => running,
      enable    => true,
      subscribe => File['/etc/sssd/sssd.conf', '/etc/nsswitch.conf', '/etc/sysconfig/authconfig', '/etc/pam.d/system-auth-ac', '/etc/pam.d/system-auth', '/etc/pam.d/password-auth-ac', '/etc/pam.d/password-auth'],
      before    => File['/etc/omniORB.cfg'], #softwaretwo group
    }
  }
}
