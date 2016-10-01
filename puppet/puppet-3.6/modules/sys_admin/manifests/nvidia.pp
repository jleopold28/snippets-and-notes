class sys_admin::nvidia() {
  #enable remote direct rendering
  if '/sbin/modprobe nvidia' {
    file_line {'access control granted during gdm initialization':
      ensure => present,
      path   => '/etc/gdm/Init/Default',
      line   => 'xhost+ #last convenient place to put this is here',
      after  => 'SETXKBMAP=`gdmwhich setxkbmap`',
    }

    file_line {'nvidia device rw permissions':
      ensure => present,
      path   => '/etc/rc.local',
      line   => '/bin/chmod 666 /dev/nvidia*',
    }

    file_line {'display manager allow tcp':
      ensure => present,
      path   => '/etc/gdm/custom.conf',
      line   => 'DisallowTCP = false',
      after  => 'security',
    }
  }
}
