# Class sysctl
# configures the sysctl.conf
class sysctl(
  String $distro = $facts['os']['name']
) {
  # configure sysctl.conf according to operating system distro
  file { '/etc/sysctl.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/sysctl.erb"),
  }
}
