class one::service {
  #$pkg_last = keys(lookup("${module_name}::packages"), Hash[String, Hash], 'hash')[-1]
  $pkg_last = keys(hiera_hash("${module_name}::packages"))[-1]
  service { 'service':
    ensure    => running,
    subscribe => Package[$pkg_last],
  }
}
