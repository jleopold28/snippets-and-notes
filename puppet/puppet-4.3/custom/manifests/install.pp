# custom::install(hash of packages in resource compatible format)
# Iterates through packages and establishes seqential dependencies.  Creates resources to install by specified hash attributes.
define custom::install(Hash $pkg_hash) {
  keys($pkg_hash).each |Integer $index, String $pkg| { if $index > 0 { Package[keys($pkg_hash)[$index - 1]] -> Package[$pkg] } }
  #keys($pkg_hash).custom::splat.each |$tuple| {
  #  with(*$tuple) |$current, $next| { Package[$current] -> Package[$next] }
  #}
  create_resources(package, $pkg_hash)
}
