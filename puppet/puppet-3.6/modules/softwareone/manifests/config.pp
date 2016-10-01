class softwareone::config() {
  #establish ldconf files for softwareone
  define ldconfs($ldconf_file, $ldconf_present)
  {
    file { "/etc/ld.so.conf.d/$ldconf_file":
      ensure => $ldconf_present,
      mode   => '0644',
      source => "puppet:///modules/softwareone/$ldconf_file",
      owner  => root,
      group  => root,
    }
    exec { "ldconfig_$ldconf_file":
      command     => '/sbin/ldconfig',
      subscribe   => File["/etc/ld.so.conf.d/$ldconf_file"],
      refreshonly => true,
    }
  }

  $softwareone_ldconfs = {
    'flites'      => { ldconf_file    => 'flites.conf',
                       ldconf_present => present,
    },
    'softwareone' => { ldconf_file    => 'softwareone.conf',
                       ldconf_present => present,
    },
  }

  create_resources(ldconfs, $softwareone_ldconfs)

  #establish default profile environment for softwareone
  define envs($env_file, $env_present)
  {
    file { "/etc/profile.d/$env_file":
      ensure => $env_present,
      source => "puppet:///modules/softwareone/$env_file",
      owner  => root,
      group  => root,
    }
    exec { "profile_$env_file":
      command     => "/bin/bash -c 'source /etc/profile.d/$env_file'",
      subscribe   => File["/etc/profile.d/$env_file"],
      refreshonly => true,
    }
  }

  $softwareone_envs = {
    'pvm'         => { env_file    => 'pvm3.sh',
                       env_present => present,
    },
    'softwareone' => { env_file    => 'softwareone.sh',
                       env_present => present,
    },
  }

  create_resources(envs, $softwareone_envs)
}
