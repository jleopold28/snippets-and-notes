class app::install() {
  $packages = {
    'one' => { ensure => '1.1-1' },
    'two' => { ensure => '2.2-2' },
    'three' => { ensure => '3.3-3' },
    'four' => { ensure => '4.4-4' },
    'five' => { ensure => '5.5-5' }
  }
  if hiera('app::downgrade', false) {
    custom::install { "${module_name}::install": pkg_hash => $packages }
  }
  else {
    custom::app_install { "${module_name}::install": pkg_hash => $packages }
  }

  ['six', 'seven', 'eight'].each |$rpm| {
    package { $rpm:
      ensure   => absent,
      provider => rpm,
    }
  }
}
