# base install and config class for icinga
class icinga::base(String $icinga_version = '2.5.4') {
  # setup repo subs; TODO: yum hates redoing this
  package { ['https://packages.icinga.org/epel/7/release/noarch/icinga-rpm-release-7-1.el7.centos.noarch.rpm', 'epel-release']: ensure => installed }

  # install base packages
  package { ['icinga2', 'icinga2-selinux', 'icinga2-ido-pgsql']:
    ensure  => $icinga_version,
    require => Package['https://packages.icinga.org/epel/7/release/noarch/icinga-rpm-release-7-1.el7.centos.noarch.rpm', 'epel-release'],
  }

  package { 'nagios-plugins-all':
    ensure  => installed,
    require => Package['epel-release'],
  }

  # enable ido-pgsql feature
  exec { '/sbin/icinga2 feature enable ido-pgsql':
    require     => Package['icinga2'],
    subscribe   => File['/etc/icinga2/features-available/ido-pgsql.conf'],
    refreshonly => true,
  }

  # enable external command feature
  exec { '/sbin/icinga2 feature enable command':
    require     => Package['icinga2'],
    # TODO: idempotent
  }

  # run icinga service
  service { 'icinga2':
    ensure    => running,
    enable    => true,
    subscribe => [Package['icinga2'], Exec['/sbin/icinga2 feature enable ido-pgsql', '/sbin/icinga2 feature enable command']],
  }
}
