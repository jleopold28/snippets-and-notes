class softwaretwo() {
  class { 'softwaretwo::install': require => Class['dev_ops::gpg'] }
  class { 'softwaretwo::config': }
}
