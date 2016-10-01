class gitlab::postinstall_config() {
  #gitlab ssl cert support
  file { '/etc/gitlab/ssl':
    ensure  => directory,
    mode    => '0755',
    require => Package['gitlab'],
    before  => File["/etc/gitlab/ssl/${::fqdn}.key", "/etc/gitlab/ssl/${::fqdn}.crt"],
  }

  file { "/etc/gitlab/ssl/${::fqdn}.key":
    ensure => file,
    owner  => root,
    group  => root,
    source => "puppet:///modules/${module_name}/${::fqdn}.key",
  }
  file { "/etc/gitlab/ssl/${::fqdn}.crt":
    ensure => file,
    owner  => root,
    group  => root,
    source => "puppet:///modules/${module_name}/${::fqdn}.crt",
  }

  #gitlab configure options
  file { '/etc/gitlab/gitlab.rb':
    ensure  => file,
    content => template("${module_name}/gitlab.erb"),
    backup  => '.bak',
    require => Package['gitlab'],
  }

  #gitlab (re)config and (re)start
  exec { 'gitlab settings (re)config':
    command     => '/opt/gitlab/bin/gitlab-ctl reconfigure',
    subscribe   => [File['/etc/gitlab/gitlab.rb', "/etc/gitlab/ssl/${::fqdn}.key", "/etc/gitlab/ssl/${::fqdn}.crt"], Package['gitlab']],
    refreshonly => true,
  }

  service { 'gitlab services':
    ensure    => running,
    start     => '/opt/gitlab/bin/gitlab-ctl start',
    restart   => '/opt/gitlab/bin/gitlab-ctl restart',
    status    => '/opt/gitlab/bin/gitlab-ctl status',
    subscribe => Exec['gitlab settings (re)config'],
  }

  #daily backup; note backups are auto-deleted by gitlab after five days
  cron { 'gitlab database backup':
    ensure  => present,
    user    => root,
    hour    => 0,
    minute  => 0,
    command => '/opt/gitlab/bin/gitlab-rake gitlab:backup:create',
    require => Package['gitlab'],
  }

  #git hooks propagation
  file { '/opt/gitlab/hooks':
    ensure  => directory,
    require => Mount['/opt/gitlab']
  }

  ['post-update', 'pre-receive', 'commit_hooks'].each |$hook_script| {
    file { "/opt/gitlab/hooks/${hook_script}":
      ensure  => present,
      owner   => git,
      group   => git,
      source  => "puppet:///modules/${module_name}/${hook_script}",
      require => [File['/opt/gitlab/hooks'], Package['gitlab']],
      before  => Exec['/bin/find /var/opt/gitlab/git-data/repositories -type d -name hooks -exec /bin/cp -af /opt/gitlab/hooks/* \'{}\' \;'],
    }
  }

  exec { '/bin/find /var/opt/gitlab/git-data/repositories -type d -name hooks -exec /bin/cp -af /opt/gitlab/hooks/* \'{}\' \;': }
}
