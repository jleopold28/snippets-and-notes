class gitlab::preinstall_config() {
  #prep the filesystem for the install
  file { ['/opt/gitlab', '/var/opt/gitlab']: ensure  => directory }

  logical_volume { 'lv_opt_gitlab':
    ensure       => present,
    initial_size => '1.50G',
    size         => '1.50G',
    volume_group => vg01,
  }
  filesystem { '/dev/vg01/lv_opt_gitlab':
    ensure  => present,
    fs_type => ext4,
    require => Logical_volume['lv_opt_gitlab'],
  }
  mount { '/opt/gitlab':
    ensure  => mounted,
    device  => '/dev/vg01/lv_opt_gitlab',
    fstype  => ext4,
    options => defaults,
    dump    => 1,
    pass    => 2,
    atboot  => true,
    require => [Filesystem['/dev/vg01/lv_opt_gitlab'], File['/opt/gitlab']],
  }

  logical_volume { 'lv_var_gitlab':
    ensure       => present,
    initial_size => $repo_size,
    size         => $repo_size,
    volume_group => vg01,
  }
  filesystem { '/dev/vg01/lv_var_gitlab':
    ensure  => present,
    fs_type => ext4,
    require => Logical_volume['lv_var_gitlab'],
  }
  mount { '/var/opt/gitlab':
    ensure  => mounted,
    device  => '/dev/vg01/lv_var_gitlab',
    fstype  => ext4,
    options => defaults,
    dump    => 1,
    pass    => 2,
    atboot  => true,
    require => [Filesystem['/dev/vg01/lv_var_gitlab'], File['/var/opt/gitlab']],
  }

  #misc gitlab service requirement
  service { 'postfix':
    ensure    => running,
    enable    => true,
    subscribe => Package['postfix'],
  }

  #open firewalls for https and ssh
  ['https', 'ssh'].each |$service| {
    file_line { "${service} firewall open":
      ensure  => present,
      path    => '/etc/sysconfig/system-config-firewall',
      line    => "--service=${service}",
      require => Package['system-config-firewall-base'],
    }
  }

  #temporarily stop three services in case of upgrade; this needs to occur before gitlab package resource but also needs gitlab to be installed first, and this split install/update attribute feature is not intrinsic to puppet
  if '/bin/ls /opt/gitlab/bin/gitlab-ctl' {
    ['unicorn', 'sidekiq', 'nginx'].each |$service| {
      service { "gitlab ${service}":
        ensure => stopped,
        stop   => "/opt/gitlab/bin/gitlab-ctl stop ${service}",
        status => "/opt/gitlab/bin/gitlab-ctl status ${service}",
      }
    }
  }
}
