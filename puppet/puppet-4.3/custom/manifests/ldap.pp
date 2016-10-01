#custom::ldap(name of ldap_conf file with no extension, originating module name)
#Generates the ldap_conf file from a template and places into tmp.  Executes java ldap command on the ldap_conf.  Executes aaa if necessary.
define custom::ldap(String $ldap_conf, String $module = $caller_module_name) {
  file { "/tmp/${ldap_conf}.ldap_conf":
    ensure  => file,
    content => template("${module}/${ldap_conf}.erb"),
    mode    => '0777',
  }
  exec { "/path/to/java LDAPModify -h localhost -D \"cn=CN\" -w `cat /ldap/.password` -a -c -f /tmp/${ldap_conf}.ldap_conf":
    environment => 'CLASSPATH=/path/to/ldapjdk.jar:/path/to/ldapfilt.jar',
    subscribe   => File["/tmp/${ldap_conf}.ldap_conf"],
    refreshonly => true,
    notify      => Exec["${module} aaa"],
  }
  ensure_resource('exec', "${module} aaa", { command => '/bin/aaa' , refreshonly => true })
}
