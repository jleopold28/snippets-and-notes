['classone', 'classtwo'].each |String $class| {
  class { $class: }
  notify { $class: }
}

['hello', 'world'].each |String $line| {
  file_line { 'file':
    ensure => present,
    path   => '/file',
    line   => $line,
  }
}

{ mcollective => { ensure => running,
                   enable => true
                 },
  puppet      => { ensure => stopped,
                   enable => false
                 }
}.each |String $title, Hash $attributes| {
  service { $title:
    ensure => $attributes['ensure'],
    enable => $attributes['enable'],
  }
}
