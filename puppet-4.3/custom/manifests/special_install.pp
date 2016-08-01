# custom::special_install(hash of packages in resource compatible format)
# Iterates through packages and establishes seqential dependencies. Updates packages if they are newer than what is installed.
define custom::special_install(Hash $pkg_hash) {
  keys($pkg_hash).each |Integer $index, String $pkg| { if $index > 0 { Package[keys($pkg_hash)[$index - 1]] -> Package[$pkg] } }
  #keys($pkg_hash).custom::splat.each |$tuple| {
  #  with(*$tuple) |$current, $next| { Package[$current] -> Package[$next] }
  #}

  $pkg_hash.each |String $pkg, Hash $attributes| {
    # only install package if older version installed or not installed
    if rpm_version_comp($pkg, $attributes['ensure']) == 1 {
      package { $pkg: ensure => $attributes['ensure'] }
    }
    # still need to generate a package resource so dependencies do not get screwed up
    else {
      package { $pkg: ensure => installed }
    }
  }
}
