# Class dns
# configures the resolv.conf
class dns(
  Array[String] $nameservers
) {
  # puppet does not allow this for module data because it enforce data namespaces which force automatic paramter binding overrides, so redundant data is stored in portland
  # lookup('dns::nameservers', Array[String], 'unique')

  # configure resol.vconf according to location
  file { '/etc/resolv.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/resolv.erb"),
  }
}
