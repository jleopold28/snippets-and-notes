class puppet_vagrant_support (

)
{
  if vagrant_version_ge('1.9.5') {
    file { '/etc/resolv.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "nameserver 8.8.8.8\nnameserver8.8.4.4"
    }
  }

  # place ssh keys
  file { "${facts['vagrant_home']}/.ssh/id_rsa":
    ensure => file,
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => '0600',
    source => 'puppet:///modules/puppet_vagrant_support/id_rsa'
  }

  # not worth injecting stdlib as a dep
  exec { "/bin/echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGtMqLN+peIDQ2vOLGFXsYWLrEfELvsvrj0HNBoG76Wh0Vv7rlP+croqY7jY+q8ggNd+ZHP+KAhqffQW72yoD1QgjP3USqDs6ZLyYNduYHF5OhyysGM2HyXagfMv9wIr9lCn/c9tnNkCc22Lm+MN/VQK1OPjbp9H51leDsxAIGgKYFzpGtqCIuUWpO4OGHkp9OPTUdAtsQo4NwvuDjEgGg35pg4vgnabQvr0k+ISVCjWB8NAehbyplAl5+e5ESGmtf03KtSMbQNM/gDHjVd/IMDG72FfcO3QvWLSlSAjk+UVRtGMylnCvGZiUV03N78TtFFKhQaflqyS/T1iCnRp7X0p9KzxNZCs20z38+0iyYAiTfdLaO2oFkQJepJL5J1TURUTWunaihCo0ba8+4sCtaX+V+KMCd+yWcxESSRo6bWPzUR1FLuJ/WsH5cTjCf/rbCbmvbIaNakaj2qOUY30aw82Mt1Ww2/xz6pXXB50htlguTVrd3sROH8OWWRQ5ChWytS7ULTI6tS5Ov3xSLEIsUvP/WamTYHmd980un8WPKqRCjAsz1wLcxtbA0EEMSzJLYXdKBkY2PHQQk8UNpaQb6UeXE+pY57j1I04lqV/7qWEJhmpBubzQBpqWyg4J30mtZvQaI6FJBwWrEKQaRbJcOG+oAEGKIz0imIJgylEzixw== vagrant@master' >> ${facts['vagrant_home']}/.ssh/authorized_keys": unless => "/bin/grep master ${facts['vagrant_home']}/.ssh/authorized_keys" }
}
