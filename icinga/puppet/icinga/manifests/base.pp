# base install and config class for icinga
class icinga::base(String $icinga_version) {
  # setup repo subs; TODO: yum hates redoing this
  yumrepo { 'Icinga2':
    baseurl  => "http://packages.icinga.org/epel/${::operatingsystemmajrelease}/release/",
    descr    => 'Icinga 2 repository',
    enabled  => 1,
    gpgcheck => 1,
    gpgkey   => 'http://packages.icinga.org/icinga.key',
  }
  yumrepo { 'EPEL':
    baseurl  => "https://dl.fedoraproject.org/pub/epel/${::operatingsystemmajrelease}/x86_64/",
    descr    => 'EPEL repository',
    enabled  => 1,
    gpgcheck => 1,
    gpgkey   => "https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-${::operatingsystemmajrelease}",
  }

  # install base packages
  package { ['icinga2', 'icinga2-selinux', 'icinga2-ido-pgsql']:
    ensure  => $icinga_version,
    require => Yumrepo['Icinga2', 'EPEL'],
  }

  package { 'nagios-plugins-all':
    ensure  => installed,
    require => Yumrepo['EPEL'],
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

  # enable ca and csr auto-signing
  exec { '/sbin/icinga2 node setup --master': creates => '/etc/icinga2/conf.d/api-users.conf' }

  # run icinga service
  service { 'icinga2':
    ensure    => running,
    enable    => true,
    subscribe => [Package['icinga2'], Exec['/sbin/icinga2 feature enable ido-pgsql', '/sbin/icinga2 feature enable command']],
    require   => Exec['/sbin/icinga2 node setup --master'],
  }

  # schedule icinga reloads
  cron { 'reload icinga2':
    ensure  => present,
    command => '/bin/systemctl reload icinga2',
    user    => 'root',
    minute  => '*/5',
  }
}
