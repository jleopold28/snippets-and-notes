#site.pp
node default {
  #full ensure no puppet daemon
  service { 'puppet':
    ensure => stopped,
    enable => false,
  }

  if $::host_group != 'vagrant' {
    #restrict puppet to cron job
    cron { 'daily puppet':
      ensure  => present,
      command => "FACTER_host_group=$::host_group FACTER_host_subgroup=$::host_subgroup /usr/bin/puppet agent -t --no-daemonize",
      user    => root,
      hour    => 0,
      minute  => 0,
    }
  }

  #subvert Foreman as ENC and use facter instead
  if ($::host_group == 'seats') or ($::host_group == 'nodes') {
    #seat and node host_group parsing occurs solely at class member level
    class { 'softwareone': }
    class { 'softwaretwo': }
    class { 'dev_ops': }
    class { 'sys_admin': }
  }
  elsif $::host_group == 'servers' {
    #server host_group parsing also occurs at sys_admin class level
    class { 'dev_ops::gpg': }
    class { 'sys_admin': }
  }
  elsif $::host_group == 'vagrant' {
    class { 'dev_ops': }
    class { 'sys_admin::nfs': }
    class { 'softwaretwo::install': require => Class['dev_ops::gpg']}
    if $::lsbmajdistrelease == '5' {
      class { 'softwareone::install':
        flites_release   => 'el5',
        softwareone_path => '/users/usertwo/softwareone',
        require          => Class['dev_ops::gpg'],
      }
    }
    elsif $::lsbmajdistrelease == '6' {
      class { 'softwareone::install':
        flites_release   => 'el6',
        softwareone_path => '/users/userone/softwareone',
        require          => Class['dev_ops::gpg'],
      }
    }
  }
}
