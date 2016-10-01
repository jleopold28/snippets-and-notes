#custom::dataload(argument to dataload script)
#Performs a standard dataload and then chowns logged output if necessary.
define custom::dataload(String $dataload) {
  exec { "/bin/ksh -c 'source /env_script; /bin/dataload ${dataload}'":
    environment => 'TMP=/private/tmp',
    umask       => '000',
    unless      => "/bin/grep \"${dataload}\" /private/tmp/*",
    notify      => Exec['/bin/chown user:group /private/tmp/*'],
  }
  ensure_resource('exec', '/bin/chown user:group /private/tmp/*', { refreshonly => true })
}
