class sys_admin::install() {
  $base_pkgs = ['rsh', 'rsh-server', 'sudo', 'ntp']

  if $::lsbmajdistrelease == '5' {
    $elversion_pkgs = ['nscd']
  }
  elsif $::lsbmajdistrelease == '6' {
    $elversion_pkgs = ['sssd', 'kdm']
  }

  $pkgs = concat($base_pkgs, $elversion_pkgs)
  package { $pkgs: ensure => latest }
}
