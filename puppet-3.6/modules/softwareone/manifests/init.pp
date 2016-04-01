class softwareone() {
  if $::lsbmajdistrelease == '5' {
    class { 'softwareone::install':
      flites_release => 'el5',
      softwareone_path    => '/users/usertwo/softwareone',
      require        => Class['dev_ops::gpg'],
    }
  }
  elsif $::lsbmajdistrelease == '6' {
    class { 'softwareone::install':
      flites_release => 'el6',
      softwareone_path    => '/users/userone/softwareone',
      require        => Class['dev_ops::gpg'],
    }
  }
  class { 'softwareone::config': }
}
