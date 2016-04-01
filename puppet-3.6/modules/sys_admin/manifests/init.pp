class sys_admin() {
  class { 'sys_admin::install': require => Class['dev_ops::gpg'] }
  class { 'sys_admin::config': }
  class { 'sys_admin::xinetd': }
  if $::host_group != 'servers' {
    class { 'sys_admin::auth': }
    class { 'sys_admin::nfs': }
    class { 'sys_admin::nvidia': require => Package['nvidia-x11-drv'] }
  }
}
