function is_client {
  if $facts['hostname'] =~ /^node/ {
    true
  }
  elsif $facts['hostname'] == 'puppet' {
    false
  }
  else {
    'unknown'
  }
}
