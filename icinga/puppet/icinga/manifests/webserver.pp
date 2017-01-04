# class to install and configure the icinga webserver
class icinga::webserver {
  # install packages for webserver
  package { 'httpd': ensure => installed }
  package { ['icingaweb2', 'icingacli']:
    ensure  => installed,
    require => Yumrepo['Icinga2', 'EPEL'],
  }

  # set php date.timezone
  file_line { 'php date.timezone UTC':
    ensure  => present,
    line    => 'date.timezone = UTC',
    path    => '/etc/php.ini',
    match   => 'date.timezone =',
    require => Package['icingaweb2'],
  }

  # start webserver
  service { 'httpd':
    ensure    => running,
    enable    => true,
    subscribe => [Package['httpd', 'icingaweb2', 'php-pgsql'], File_line['php date.timezone UTC']],
  }

  # open firewall
  exec { '/bin/firewall-cmd --add-service=http; /bin/firewall-cmd --permanent --add-service=http':
    require => Package['httpd'],
    unless  => '/bin/grep -q http /etc/sysconfig/system-config-firewall',
    returns => ['0', '252'],
  }

  # add apache to icingacmd group
  user { 'apache':
    groups  => 'icingacmd',
    require => Package['httpd', 'icinga2', 'icingaweb2'],
  }

  # create web setup token
  exec { '/bin/icingacli setup token create':
    require   => Package['icingacli'],
    logoutput => true,
    # TODO: idempotent
  }

  # icinga-web cannot access /etc/icingaweb2 if selinux is enforcing
  exec { '/sbin/setenforce 0': onlyif => '/sbin/getenforce | /bin/grep -q Enforcing' }
}
