class gitlab() {
  #we want to keep everything up to date to support gitlab and this module is tailored to the latest env supported version of gitlab
  Package { ensure => latest }

  class { 'gitlab::preinstall_config': before => Package['gitlab'] }
  class { 'gitlab::install': }
  class { 'gitlab::postinstall_config': }
}
