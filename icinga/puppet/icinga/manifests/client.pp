# class to install and configure icinga on clients
class icinga::client(
  String $icinga_version,
  String $master_fqdn
)
{
  # setup repo subs
  case $facts['os']['name'] {
    'RedHat', 'CentOS': {
      yumrepo { 'Icinga2':
        baseurl  => "http://packages.icinga.org/epel/${::operatingsystemmajrelease}/release/",
        descr    => 'Icinga 2 repository',
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => 'http://packages.icinga.org/icinga.key',
        before   => Package['icinga2'],
      }
      yumrepo { 'EPEL':
        baseurl  => "https://dl.fedoraproject.org/pub/epel/${::operatingsystemmajrelease}/x86_64/",
        descr    => 'EPEL repository',
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => "https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-${::operatingsystemmajrelease}",
        before   => Package['icinga2', 'nagios-plugins-all'],
      }
    }
    'Fedora': {
      yumrepo { 'Icinga2':
        baseurl  => "http://packages.icinga.org/fedora/${::operatingsystemmajrelease}/release/",
        descr    => 'Icinga 2 repository',
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => 'http://packages.icinga.org/icinga.key',
        before   => Package['icinga2'],
      }
    }
    # TODO: make these idempotent
    'SLES', 'OpenSUSE': {
      exec { '/usr/bin/rpm --import http://packages.icinga.org/icinga.key; zypper ar http://packages.icinga.org/openSUSE/ICINGA-release.repo; zypper ref': before => Package['icinga2'] }
    }
    'Debian': {
      file_line { 'jessie backports':
        ensure => present,
        path   => '/etc/apt/sources.list',
        line   => 'deb http://ftp.debian.org/debian jessie-backports main',
        match  => 'deb http://ftp.debian.org/debian jessie-backports main',
        before => Package['icinga2'],
      }
      file { '/etc/apt/sources.list.d/icinga.list':
        ensure  => file,
        content => 'deb http://packages.icinga.org/ubuntu icinga-jessie main',
        before  => Package['icinga2'],
      }
      exec { '/usr/bin/wget -O - http://packages.icinga.org/icinga.key | /usr/bin/apt-key add -': before => Package['icinga2'] }
    }
    'Ubuntu': {
      file { '/etc/apt/sources.list.d/icinga.list':
        ensure  => file,
        content => 'deb http://packages.icinga.org/ubuntu icinga-xenial main',
        before  => Package['icinga2'],
      }
      exec { '/usr/bin/wget -O - http://packages.icinga.org/icinga.key | /usr/bin/apt-key add -': before => Package['icinga2'] }
    }
    default: {
      fail('Unsupported OS for client.')
    }
  }

  # install base packages
  package { 'icinga2': ensure  => $icinga_version }
  package { 'nagios-plugins-all': ensure  => installed }

  # create cert dir
  file { '/etc/icinga2/pki':
    ensure  => directory,
    owner   => 'icinga',
    group   => 'icinga',
    require => Package['icinga2'],
  }

  # generate cert
  exec { "/sbin/icinga2 pki new-cert --cn ${facts['fqdn']} --key /etc/icinga2/pki/${facts['fqdn']}.key --cert /etc/icinga2/pki/${facts['fqdn']}.crt":
    require => File['/etc/icinga2/pki'],
    creates => ["/etc/icinga2/pki/${facts['fqdn']}.key", "/etc/icinga2/pki/${facts['fqdn']}.key"],
  }

  # save the cert
  exec { "/sbin/icinga2 pki save-cert --key /etc/icinga2/pki/${facts['fqdn']}.key --cert /etc/icinga2/pki/${facts['fqdn']}.crt --trustedcert /etc/icinga2/pki/${master_fqdn}.crt --host ${master_fqdn}":
    require => [Exec["/sbin/icinga2 pki new-cert --cn ${facts['fqdn']} --key /etc/icinga2/pki/${facts['fqdn']}.key --cert /etc/icinga2/pki/${facts['fqdn']}.crt"], File["/etc/icinga2/pki/${master_fqdn}"]],
    creates => "/etc/icinga2/pki/${master_fqdn}",
  }

  # copy over and execute ruby script to request ticket and finish client setup
  file { '/tmp/node_setup.rb':
    ensure  => file,
    content => template('icinga/node_setup.erb'),
  }

  exec { 'ruby /tmp/node_setup.rb':
    path        => ['/opt/puppetlabs/puppet/bin', '/usr/bin'],
    require     => File['/tmp/node_setup.rb'],
    subscribe   => Exec["/sbin/icinga2 pki save-cert --key /etc/icinga2/pki/${facts['fqdn']}.key --cert /etc/icinga2/pki/${facts['fqdn']}.crt --trustedcert /etc/icinga2/pki/${master_fqdn}.crt --host ${master_fqdn}"],
    refreshonly => true,
  }

  # disable recursive conf.d inclusion
  file_line { 'comment out include_recursive conf.d':
    ensure => present,
    path   => '/etc/icinga2/icinga2.conf',
    line   => '//include_recursive "conf.d"',
    match  => 'include_recursive "conf.d"',
  }

  # restart icinga after changes
  service { 'icinga2':
    ensure    => running,
    enable    => true,
    subscribe => [Package['icinga2'], Exec['ruby /tmp/node_setup.rb']],
  }
}
