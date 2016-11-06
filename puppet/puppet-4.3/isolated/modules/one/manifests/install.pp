class one::install {
  #custom::install { $module_name: pkg_hash => lookup("${module_name}::packages", Hash[String, Hash], 'hash') }
  custom::install { $module_name: pkg_hash => hiera_hash("${module_name}::packages") }
}
