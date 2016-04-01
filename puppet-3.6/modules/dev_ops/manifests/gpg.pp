class dev_ops::gpg() {
  #copy and install all necessary gpg keys
  define gpg_key_import($key_file, $key_present)
  {
    file { "/etc/pki/rpm-gpg/$key_file":
      ensure => $key_present,
      owner  => root,
      group  => root,
      mode   => '0644',
      source => "puppet:///modules/dev_ops/$key_file",
    }
    exec { "/bin/rpm --import /etc/pki/rpm-gpg/$key_file":
      subscribe   => File["/etc/pki/rpm-gpg/$key_file"],
      refreshonly => true,
    }
  }

  if $::lsbmajdistrelease == '5' {
    $gpg_keys = {
      'repoforge'         => { key_file    => 'RPM-GPG-KEY.dag.txt',
                               key_present => present,
      },
      'elrepo'            => { key_file    => 'RPM-GPG-KEY-elrepo.org',
                               key_present => present,
      },
      'puppet'            => { key_file    => 'RPM-GPG-KEY-puppetlabs',
                               key_present => present,
      },
      'department'        => { key_file    => 'RPM-GPG-KEY-RHEL5-userone',
                               key_present => present,
      },
      'department_legacy' => { key_file    => 'RPM-GPG-KEY-userthree',
                               key_present => present,
      },
      'epel'              => { key_file    => 'RPM-GPG-KEY-EPEL-5',
                               key_present => present,
      },
      'spacewalk'         => { key_file    => 'RPM-GPG-KEY-spacewalk-2012',
                               key_present => present,
      },
    }
  }
  elsif $::lsbmajdistrelease == '6' {
    $gpg_keys = {
      'repoforge'         => { key_file    => 'RPM-GPG-KEY.dag.txt',
                               key_present => present,
      },
      'elrepo'            => { key_file    => 'RPM-GPG-KEY-elrepo.org',
                               key_present => present,
      },
      'puppet'            => { key_file    => 'RPM-GPG-KEY-puppetlabs',
                               key_present => present,
      },
      'department'        => { key_file    => 'RPM-GPG-KEY-RHEL6-userone',
                               key_present => present,
      },
      'rpmfusion_nonfree' => { key_file    => 'RPM-GPG-KEY-rpmfusion-nonfree-el-6',
                               key_present => present,
      },
      'rpmfusion_free'    => { key_file    => 'RPM-GPG-KEY-rpmfusion-free-el-6',
                               key_present => present,
      },
      'epel'              => { key_file    => 'RPM-GPG-KEY-EPEL-6',
                               key_present => present,
      },
      'spacewalk'         => { key_file    => 'RPM-GPG-KEY-spacewalk-2012',
                               key_present => present,
      },
    }
  }

  create_resources(gpg_key_import, $gpg_keys)

  if $::operatingsystem == 'RedHat' {
    exec { '/bin/rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-*; /bin/touch /etc/pki/rpm-gpg/redhat-gpg-imported': creates => '/etc/pki/rpm-gpg/redhat-gpg-imported' }
  }
  elsif $::operatingsystem == 'CentOS' {
    exec { '/bin/rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-*; /bin/touch /etc/pki/rpm-gpg/centos-gpg-imported': creates => '/etc/pki/rpm-gpg/centos-gpg-imported' }
  }
}
