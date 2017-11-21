# Class profile::base
# base profile to be applied to all nodes
class profile::base {
  include ntp
  include dns
  include sysctl

  lookup('profile::base::swap_file', Hash).each |String $title, Hash $attributes| {
    swap_file::files { $title: * => $attributes }
  }
  # create_resources('swap_file::files', lookup('profile::base::swap_file', Hash))
}
