class softwareone::install($flites_release, $softwareone_path) {
  #install necessary softwareone packages
  if $::lsbmajdistrelease == '5' {
    if $::host_group == 'nodes' {
      $pkgs = ['gcc44-gfortran', 'gcc-gnat', 'ncurses', 'libxml++', 'gtk2', 'gtkmm24', 'gsl', 'tcl', 'tk', 'hdf5.x86_64', 'CERTI', 'levmar', 'pvm', 'glew', 'freeglut', 'libXmu', 'ffmpeg', 'libX11', 'cuda', 'libtiff', 'bzip2-libs', 'sundials', 'libpng', 'fltk', 'sgip']
    }
    elsif ($::host_group == 'seats') or ($::host_group == 'vagrant') {
      $pkgs = ['cmake', 'gcc44-gfortran', 'gcc-gnat', 'ncurses-devel', 'libxml++-devel', 'gtk2-devel', 'gtkmm24-devel', 'gsl-devel', 'tcl-devel', 'tk-devel', 'hdf5-devel.x86_64', 'CERTI', 'levmar', 'pvm', 'glew-devel', 'freeglut-devel', 'libXmu', 'ffmpeg-devel', 'libX11-devel', 'cuda', 'libtiff-devel', 'bzip2-devel', 'sundials-devel', 'libpng-devel', 'fltk-devel', 'sgip-devel']
    }
  }
  elsif $::lsbmajdistrelease == '6' {
    if $::host_group == 'nodes' {
      $pkgs = ['gcc-gfortran', 'gcc-gnat', 'ncurses', 'libxml++', 'gtk2', 'gtkmm24', 'gsl', 'tcl', 'tk', 'hdf5-1.8.5.patch1-7.el6', 'CERTI', 'levmar', 'pvm', 'glew', 'freeglut', 'libXmu', 'ffmpeg-libs', 'libX11', 'cuda4', 'cuda', 'libtiff', 'bzip2-libs', 'sundials', 'libpng', 'fltk', 'sgip']
    }
    elsif ($::host_group == 'seats') or ($::host_group == 'vagrant') {
      $pkgs = ['cmake', 'gcc-gfortran', 'gcc47-gfortran', 'gcc-gnat', 'gcc47-gnat', 'ncurses-devel', 'libxml++-devel', 'gtk2-devel', 'gtkmm24-devel', 'gsl-devel', 'tcl-devel', 'tk-devel', 'hdf5-devel-1.8.5.patch1-7.el6', 'CERTI', 'levmar', 'pvm', 'glew-devel', 'freeglut-devel', 'libXmu', 'ffmpeg-devel', 'libX11-devel', 'cuda4', 'cuda', 'libtiff-devel', 'bzip2-devel', 'sundials-devel', 'libpng-devel', 'fltk-devel', 'sgip-devel']
    }
  }

  package { $pkgs: ensure => latest }

  #copy flites (unclassified only)
  file { '/usr/local/flites':
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0755',
  }

  file { "/root/flites_$flites_release.tar.gz":
    ensure  => present,
    owner   => root,
    group   => root,
    source  => "puppet:///modules/softwareone/flites_$flites_release.tar.gz",
    require => File['/usr/local/flites'],
  }
  if $::host_group != 'vagrant' {
    exec { "/bin/tar -C /usr/local/flites -xvzf /root/flites_$flites_release.tar.gz; /bin/chown -R root:flites /usr/local/flites/*":
      subscribe   => File["/root/flites_$flites_release.tar.gz"],
      refreshonly => true,
    }
  }
  else {
    exec { "/bin/tar -C /usr/local/flites -xvzf /root/flites_$flites_release.tar.gz":
      subscribe   => File["/root/flites_$flites_release.tar.gz"],
      refreshonly => true,
    }
  }

  #symlinks for networked softwareone
  file { '/usr/share/softwareone':
    ensure => link,
    target => "$softwareone_path/data",
  }
  file { '/usr/share/doc/softwareone':
    ensure => link,
    target => "$softwareone_path/doc",
  }

  #legacy symlinks for networked softwareone
  file { '/usr/local/softwareone':
    ensure  => directory,
    require => Mount['/zfs/usertwo', '/zfs/userone'],
  }

  define legacy_symlinks($legacy_symlink, $legacy_ensure, $softwareone_path)
  {
    file { "/usr/local/softwareone/$legacy_symlink":
      ensure  => $legacy_ensure,
      target  => "$softwareone_path/$legacy_symlink",
      require => File['/usr/local/softwareone'],
    }
  }

  $softwareone_legacy_symlinks = {
    'data' => { legacy_symlink => 'data',
                legacy_ensure => present,
                softwareone_path => $softwareone_path,
              },
    'doc'  => { legacy_symlink => 'doc',
                legacy_ensure => present,
                softwareone_path => $softwareone_path,
              },
    'bin'  => { legacy_symlink => 'bin',
                legacy_ensure => present,
                softwareone_path => $softwareone_path,
              },
    'lib'  => { legacy_symlink => 'lib',
                legacy_ensure => present,
                softwareone_path => $softwareone_path,
              },
    'src'  => { legacy_symlink => 'src',
                legacy_ensure => present,
                softwareone_path => $softwareone_path,
              },
  }

  create_resources(legacy_symlinks, $softwareone_legacy_symlinks)
}
