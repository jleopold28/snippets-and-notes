# Class ntp
# configures the ntp.conf
class ntp(
  Array[String] $ntpservers
) {
  # lookup function for reference
  # lookup('ntp::ntpservers', Array[String])

  # configure ntp.conf according to location
  file { '/etc/ntp.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/ntp.erb"),
  }
}
