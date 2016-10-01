class dev_ops() {
  class { 'dev_ops::gpg': }
  class { 'dev_ops::install': require => Class['dev_ops::gpg']}
  class { 'dev_ops::config': }
}
