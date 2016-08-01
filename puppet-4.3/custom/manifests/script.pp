#custom::script(script name, originating module name, additional file attributes for script copy, additional exec attributes for script exec)
#Places a script from puppet:///modules/module into /tmp according to standard attributes plus any additional specified in arguments.  Executes the script according to standard attributes plus any additional specified in arguments.

#TODO: add template capability
define custom::script(String $script, String $module = $caller_module_name, Hash $file_attr = {}, Hash $exec_attr = {}) {
  file { "/tmp/${script}":
    ensure => file,
    source => "puppet:///modules/${module}/${script}",
    *      => $file_attr,
  }
  exec { "/bin/ksh /tmp/${script}":
    subscribe   => File["/tmp/${script}"],
    refreshonly => true,
    *           => $exec_attr,
  }
}
