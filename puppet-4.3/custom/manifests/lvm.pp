#custom::lvm(hash of logical volumes and filesystems)
#Creates physical volumes, volume groups, logical volumes, filesystems, directories, mounts, and more, according to custom specifications and supplied hieradata.
define custom::lvm(Hash $lvm_hash) {
  physical_volume { '/dev/sda2': ensure => present }
  volume_group { 'vg00':
    ensure           => present,
    physical_volumes => '/dev/sda2',
  }

  #TODO: fact or data? keys(facts['disks'])
  #$physical_volumes = lookup('physical_volumes', Array[String], 'unique')
  $physical_volumes = hiera_array('physical_volumes')
  $physical_volumes.each |String $phys_vol| {
    exec { "/bin/echo 'n\np\n1\n1\n\nt\n8e\nw' | /sbin/fdisk /dev/${phys_vol}":
      unless => "/bin/lsblk | /bin/grep ${phys_vol}1",
      before => Physical_volume["/dev/${phys_vol}1"],
    }
  }
  $partitions = $physical_volumes.map |String $phys_vol| { "/dev/${phys_vol}1" }
  $partitions.each |String $partition| {
    physical_volume { $partition:
      ensure => present,
      before => Volume_group['vg01'],
    }
  }
  volume_group { 'vg01':
    ensure           => present,
    physical_volumes => $partitions,
  }

  $lvm_hash.each |String $title, Hash $lvm| {
    if $lvm['dir'] == 'raw' {
      logical_volume { $lvm['device']:
        ensure       => present,
        initial_size => $lvm['size'],
        size         => $lvm['size'],
        volume_group => vg01,
        require      => Volume_group['vg01'],
      }
      if $title[-2] == '0' {
        $raw_num = $title[-1]
      }
      else {
        $raw_num = "${title[-2]}${title[-1]}"
      }
      file_line { "udevrule /dev/vg01/${lvm['device']}":
        ensure  => present,
        path    => '/etc/udev/rules.d/60-raw.rules',
        line    => "ACTION==\"add|change\", ENV{DM_VG_NAME}==\"vg01\", ENV{DM_LV_NAME}==\"${lvm['device']}\", RUN+=\"/bin/raw /dev/raw/raw${raw_num} %N\"",
        match   => ".*${lvm['device']}.*raw${raw_num}.*",
        require => Logical_volume[$lvm['device']],
        before  => File_line['udevrule kernel'],
      }
    }
    elsif $lvm['dir'] == 'swap' {
      #TODO: this swapoff doesn't really need to happen everytime
      exec { "/sbin/swapoff /dev/vg01/${lvm['device']}": onlyif => "/bin/grep ${lvm['device']} /etc/fstab" }
      logical_volume { $lvm['device']:
        ensure       => present,
        initial_size => $lvm['size'],
        size         => $lvm['size'],
        volume_group => vg01,
        require      => [Exec["/sbin/swapoff /dev/vg01/${lvm['device']}"], Volume_group['vg01']],
      }
      filesystem { "/dev/vg01/${lvm['device']}":
        ensure    => present,
        fs_type   => swap,
        subscribe => Logical_volume[$lvm['device']],
      }
      mount { $lvm['dir']:
        device    => "/dev/vg01/${lvm['device']}",
        fstype    => swap,
        options   => defaults,
        dump      => 0,
        pass      => 0,
        atboot    => true,
        subscribe => Filesystem["/dev/vg01/${lvm['device']}"],
      }
      exec { "/sbin/swapon /dev/vg01/${lvm['device']}":
        unless      => "/bin/grep `/bin/readlink -f /dev/vg01/${lvm['device']}` /proc/swaps",
        subscribe   => [Mount[$lvm['dir']], Exec["/sbin/swapoff /dev/vg01/${lvm['device']}"]],
        refreshonly => true,
      }
    }
    else {
      if $lvm['size'] == 0 {
        mount { $lvm['dir']:
          ensure  => absent,
          device  => "/dev/vg01/${lvm['device']}",
          atboot  => false,
          require => Volume_group['vg01'],
        }
        filesystem { "/dev/vg01/${lvm['device']}":
          ensure  => absent,
          require => Mount[$lvm['dir']],
        }
        logical_volume { $lvm['device']:
          ensure       => absent,
          volume_group => vg01,
          require      => Filesystem["/dev/vg01/${lvm['device']}"],
        }
      }
      else {
        logical_volume { $lvm['device']:
          ensure       => present,
          initial_size => $lvm['size'],
          size         => $lvm['size'],
          volume_group => vg01,
          require      => Volume_group['vg01'],
        }
        filesystem { "/dev/vg01/${lvm['device']}":
          ensure    => present,
          fs_type   => ext4,
          subscribe => Logical_volume[$lvm['device']],
        }
        file { $lvm['dir']:
          ensure => directory,
          owner  => $lvm['user'],
          group  => $lvm['group'],
          mode   => $lvm['perm'],
        }
        mount { $lvm['dir']:
          ensure    => mounted,
          device    => "/dev/vg01/${lvm['device']}",
          fstype    => ext4,
          options   => defaults,
          dump      => 1,
          pass      => 2,
          atboot    => true,
          require   => File[$lvm['dir']],
          subscribe => Filesystem["/dev/vg01/${lvm['device']}"],
        }
      }
    }
  }
  unless $facts['role'] =~ /^(id_one|id_two)_role_one$/ {
    file_line { 'udevrule kernel':
      ensure => present,
      path   => '/etc/udev/rules.d/60-raw.rules',
      line   => 'ACTION=="add|change", KERNEL=="raw*", OWNER=="65535", GROUP=="32768", MODE=="0660"',
      notify => Exec['/sbin/udevadm control --reload-rules; /sbin/udevadm trigger --action=change'],
    }
    exec { '/sbin/udevadm control --reload-rules; /sbin/udevadm trigger --action=change': refreshonly => true }
  }
}
