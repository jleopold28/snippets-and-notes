class dev_ops::config(){
  if $::lsbmajdistrelease == '6' {
    #cm monitoring and validation software
    if ($::host_group == 'seats') or ($::host_group == 'nodes') {
      file { '/root/cm_validate.rb':
        ensure  => present,
        mode    => '0700',
        owner   => root,
        group   => root,
        source  => 'puppet:///modules/dev_ops/cm_validate.rb',
        require => Package['ruby19'],
      }

      cron { 'cm monitoring/validation cron':
        ensure  => present,
        command => '/usr/bin/ruby1.9 /root/cm_validate.rb',
        user    => root,
        weekday => [0, 3],
        hour    => 22,
        minute  => 0,
        require => File['/root/cm_validate.rb'],
      }
    }

    #daemon has to be running to actually use docker
    service { 'docker':
      ensure  => running,
      enable  => true,
      require => Package['docker-io'],
    }
  }
}
