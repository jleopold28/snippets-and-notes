function is_client {
  case $facts['hostname'] {
    /^node/  : { true }
    'puppet' : { false }
    default  : { 'unknown' }
  }
}
