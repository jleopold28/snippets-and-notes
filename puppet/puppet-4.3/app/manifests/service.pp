class app::service() {
  service { 'httpd':
    ensure    => running,
    subscribe => Class['app::install'],
  }

  file { '/tmp/service.lock': ensure => file }
  service { 'service':
    ensure    => running,
    subscribe => File['/tmp/service.lock'],
    before    => Exec['/bin/rm -f /tmp/service.lock'],
  }
  exec { '/bin/rm -f /tmp/service.lock': }

  notify { 'restart service_two': }
  service { 'service_two':
    ensure    => running,
    subscribe => Notify['restart service_two'],
  }
}
