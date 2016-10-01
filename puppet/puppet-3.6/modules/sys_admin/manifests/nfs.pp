class sys_admin::nfs() {
  #mount nfs shares and link to zfs
  $user_accounts = ['users']

  $group_accounts = ['softwaretwo']

  $nfs_accounts = concat($user_accounts, $group_accounts)

  file { ['/users', '/zfs'] :
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0755',
  }

  define mount_users {
    file { "/zfs/$name":
      ensure  => directory,
      require => File['/users', '/zfs'],
    }
    file { "/users/$name":
      ensure  => link,
      target  => "/zfs/$name",
      require => File["/zfs/$name"],
      before  => Mount["/zfs/$name"],
    }
    #mount read-only in vagrant
    if $::host_group != 'vagrant' {
      mount { "/zfs/$name":
        ensure  => mounted,
        device  => "fs1.company.org:/users/$name",
        fstype  => nfs,
        options => 'rw,intr,bg,noatime,nfsvers=3,rsize=65536,wsize=65536',
        atboot  => true,
      }
    }
    else {
      mount { "/zfs/$name":
        ensure  => mounted,
        device  => "fs1.company.org:/users/$name",
        fstype  => nfs,
        options => 'ro,intr,bg,noatime,nfsvers=3,rsize=65536,wsize=65536',
        atboot  => true,
      }
    }
  }
  mount_users{ $nfs_accounts: }

}
