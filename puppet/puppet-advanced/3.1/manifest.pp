$pkg_hash = { 'glibc' => { ensure => 'installed' },
              'httpd' => { ensure => 'installed' },
              'ntpd'  => { ensure => 'installed' },
            }

create_resources(package, $pkg_hash)

$dir_hash = { '/etc/foo' => { ensure => 'directory',
                              owner  => 'vagrant',
                              group  => 'vagrant',
                              mode   => '0555',
                            },
              '/etc/bar' => { ensure => 'directory',
                              owner  => 'vagrant',
                              group  => 'vagrant',
                              mode   => '0666',
                            },
              '/etc/baz' => { ensure => 'directory',
                              owner  => 'root',
                              group  => 'root',
                              mode   => '0777',
                            },
            }

create_resources(file, $dir_hash)

$user_hash = { 'alice' => { ensure => 'present',
                            uid    => 1001,
                            gid    => 1001,
                          },
               'bob'   => { ensure => 'present',
                            uid    => 1002,
                            gid    => 1001,
                          },
             }

create_resources(user, $user_hash)
