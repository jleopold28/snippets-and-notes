# Class profile::apache
# apache profile to be applied to servers that require apache installation and configuration
class profile::apache {
  class { 'apache':
    mpm_module       => 'prefork', # needed for php module
  }

  include apache::mod::php
}
