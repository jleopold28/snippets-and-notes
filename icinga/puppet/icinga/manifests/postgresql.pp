# class to install and config postgresql backend
class icinga::postgresql {
  # setup repo sub; TODO: yum hates redoing this
  package { 'https://download.postgresql.org/pub/repos/yum/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-3.noarch.rpm': ensure => installed }

  # install postgresql
  package { ['postgresql94-server', 'postgresql94', 'php-pgsql']:
    ensure  => installed,
    require => Package['https://download.postgresql.org/pub/repos/yum/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-3.noarch.rpm', 'epel-release'],
  }

  # initialize database
  exec { '/usr/pgsql-9.4/bin/postgresql94-setup initdb':
    unless  => '/bin/ls /var/lib/pgsql/9.4/data/base/*',
    require => Package['postgresql94', 'postgresql94-server'],
  }

  # change postgres icinga ido config
  file { '/etc/icinga2/features-available/ido-pgsql.conf':
    ensure  => file,
    source  => 'puppet:///modules/icinga/ido-pgsql.conf',
    require => Package['icinga2-ido-pgsql'],
  }

  # change postgres config
  ['host    icingaweb      icingaweb      ::1/128               md5', 'host    icingaweb      icingaweb      127.0.0.1/32          md5', 'local   icingaweb      icingaweb                            md5', '# icingaweb', 'host    icinga      icinga      ::1/128               md5', 'host    icinga      icinga      127.0.0.1/32          md5', 'local   icinga      icinga                            md5', '# icinga'].each |$line| {
    file_line { $line:
      ensure  => present,
      line    => $line,
      path    => '/var/lib/pgsql/9.4/data/pg_hba.conf',
      after   => '# TYPE  DATABASE        USER            ADDRESS                 METHOD',
      require => Package['postgresql94-server'],
      notify  => Service['postgresql-9.4'],
    }
  }

  file_line { 'change default auth method':
    ensure  => present,
    line    => 'local   all             all                                     ident',
    path    => '/var/lib/pgsql/9.4/data/pg_hba.conf',
    match   => 'local   all             all                                     peer',
    require => Package['postgresql94-server'],
    notify  => Service['postgresql-9.4'],
  }

  # run postgresql service
  service { 'postgresql-9.4':
    ensure    => running,
    enable    => true,
    subscribe => Package['postgresql94', 'postgresql94-server'],
  }

  # create icinga/icingaweb database and user
  exec { '/usr/pgsql-9.4/bin/psql -c "CREATE ROLE icinga WITH LOGIN PASSWORD \'icinga\'"; /usr/pgsql-9.4/bin/createdb -O icinga -E UTF8 icinga; /usr/pgsql-9.4/bin/psql -c "CREATE ROLE icingaweb WITH LOGIN PASSWORD \'icingaweb\'"; /usr/pgsql-9.4/bin/createdb -O icingaweb -E UTF8 icingaweb; /usr/pgsql-9.4/bin/createlang plpgsql icinga':
    cwd         => '/tmp',
    user        => 'postgres',
    returns     => ['0', '2'],
    subscribe   => Exec['/usr/pgsql-9.4/bin/postgresql94-setup initdb'],
    refreshonly => true,
    require     => Service['postgresql-9.4'],
  }

  # setup postgres icinga ido
  exec { '/usr/pgsql-9.4/bin/psql -U icinga -d icinga < /usr/share/icinga2-ido-pgsql/schema/pgsql.sql':
    environment => 'PGPASSWORD=icinga',
    require     => [Package['icinga2-ido-pgsql'], Service['postgresql-9.4']],
    subscribe   => Exec['/usr/pgsql-9.4/bin/postgresql94-setup initdb'],
    refreshonly => true,
  }
}
