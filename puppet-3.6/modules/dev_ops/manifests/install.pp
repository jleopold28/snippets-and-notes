class dev_ops::install() {
  #install standard development environment and dual softwareone/softwaretwo packages
  if $::lsbmajdistrelease == 5 {
    if $::host_group == 'nodes' {
      $dev_pkgs = ['meld', 'vim-X11', 'emacs', 'puppet', 'python27', 'gnuplot', 'ImageMagick', 'xfig', 'valgrind', 'kdesdk', 'kdegraphics', 'vlc', 'smplayer', 'mencoder', 'sqlite', 'python-sqlite2', 'inkscape', 'ddd', 'perl.x86_64', 'kdbg', 'python-matplotlib', 'python-dateutil', 'graphviz.x86_64', 'perl-Perl-Tidy', 'rpm', 'gnupg2']
      $softwareone_softwaretwo_pkgs = ['gcc44', 'gcc44-c++', 'libxml2', 'qt4-department', 'boost', 'nvidia-x11-drv' ]
    }
    elsif $::host_group == 'seats' {
      $dev_pkgs = ['subversion', 'meld', 'vim-X11', 'emacs', 'mysql-query-browser', 'puppet', 'python27', 'firefox', 'octave', 'gnuplot', 'ImageMagick', 'xfig', 'blender', 'rdesktop', 'valgrind', 'kdesdk', 'kdegraphics', 'vlc', 'smplayer', 'mencoder', 'asymptote', 'thunderbird', 'texmaker', 'sqlite', 'python-sqlite2', 'inkscape', 'wxMaxima', 'openoffice.org-base', 'ddd', 'pidgin', 'perl.x86_64', 'kdbg', 'python-matplotlib', 'python-dateutil', 'k3b', 'doxygen', 'doxygen-doxywizard', 'doxygenfilter', 'graphviz.x86_64', 'perl-Perl-Tidy', 'rpm', 'gnupg2']
      $softwareone_softwaretwo_pkgs = ['gcc44', 'gcc44-c++', 'flex', 'bison', 'libxml2-devel', 'qt4-department', 'boost-devel', 'nvidia-x11-drv' ]
    }
    elsif $::host_group == 'vagrant' {
      $dev_pkgs = ['subversion', 'meld', 'vim-X11', 'emacs', 'puppet', 'python27', 'gnuplot', 'ImageMagick', 'xfig', 'blender', 'valgrind', 'kdesdk', 'kdegraphics', 'vlc', 'smplayer', 'mencoder', 'sqlite', 'python-sqlite2', 'inkscape', 'wxMaxima', 'ddd', 'perl.x86_64', 'kdbg', 'python-matplotlib', 'python-dateutil', 'doxygen', 'doxygen-doxywizard', 'doxygenfilter', 'graphviz.x86_64', 'perl-Perl-Tidy', 'rpm', 'gnupg2']
      $softwareone_softwaretwo_pkgs = ['gcc44', 'gcc44-c++', 'flex', 'bison', 'libxml2-devel', 'qt4-department', 'boost-devel', 'nvidia-x11-drv' ]
    }
  }
  elsif $::lsbmajdistrelease == 6 {
    if $::host_group == 'nodes' {
      $dev_pkgs = ['meld', 'vim-X11', 'emacs', 'gridengine-qmon', 'gridengine-execd', 'puppet', 'lapack', 'blas', 'graphviz', 'python27', 'gnuplot44', 'ImageMagick', 'xfig', 'valgrind', 'kdesdk', 'kdegraphics', 'vlc', 'smplayer', 'mencoder', 'sqlite', 'python-sqlite2', 'PyQt4', 'inkscape', 'nemiver', 'ddd', 'ds9', 'perl', 'kdeutils', 'perltidy', 'python27-pandas', 'rpm', 'gnupg2', 'ruby19', 'docker-io']
      $softwareone_softwaretwo_pkgs = ['gcc', 'gcc-c++', 'libxml2', 'qt', 'boost', 'nvidia-x11-drv']
    }
    elsif $::host_group == 'seats' {
      $dev_pkgs = ['subversion', 'meld', 'vim-X11', 'emacs', 'mysql-workbench-community', 'gridengine-qmon', 'gridengine-execd', 'puppet', 'lapack-devel', 'blas-devel', 'graphviz-devel', 'python27', 'firefox', 'octave', 'gnuplot44', 'texlive-latex', 'ImageMagick', 'xfig', 'blender', 'rdesktop', 'valgrind', 'kdesdk', 'kdegraphics', 'vlc', 'smplayer', 'mencoder', 'asymptote', 'thunderbird', 'texmaker', 'sqlite', 'python-sqlite2', 'PyQt4', 'inkscape', 'wxMaxima', 'libreoffice', 'nemiver', 'ddd', 'ds9', 'pidgin', 'perl', 'kdeutils', 'kdebase', 'kdebase-workspace', 'k3b', 'doxygen', 'doxygen-doxywizard', 'rapidsvn', 'qt-creator', 'doxygenfilter', 'perltidy', 'python27-pandas', 'rpm', 'gnupg2', 'ruby19', 'vagrant', 'docker-io']
      $softwareone_softwaretwo_pkgs = ['gcc', 'gcc48', 'gcc-c++', 'gcc48-c++', 'flex', 'bison', 'libxml2-devel', 'qt-devel', 'boost-devel', 'nvidia-x11-drv', 'cmake28']
    }
    elsif $::host_group == 'vagrant' {
      $dev_pkgs = ['subversion', 'meld', 'vim-X11', 'emacs', 'puppet', 'lapack-devel', 'blas-devel', 'graphviz-devel', 'python27', 'gnuplot44', 'ImageMagick', 'xfig', 'blender', 'valgrind', 'kdesdk', 'kdegraphics', 'vlc', 'smplayer', 'mencoder', 'sqlite', 'python-sqlite2', 'PyQt4', 'inkscape', 'wxMaxima', 'nemiver', 'ddd', 'ds9', 'perl', 'kdeutils', 'doxygen', 'doxygen-doxywizard', 'rapidsvn', 'qt-creator', 'doxygenfilter', 'perltidy', 'python27-pandas', 'rpm', 'gnupg2', 'docker-io']
      $softwareone_softwaretwo_pkgs = ['gcc', 'gcc48', 'gcc-c++', 'gcc48-c++', 'flex', 'bison', 'libxml2-devel', 'qt-devel', 'boost-devel', 'nvidia-x11-drv', 'cmake28']
    }
  }

  $pkgs = concat($dev_pkgs, $softwareone_softwaretwo_pkgs)
  package { $pkgs : ensure => latest }

  if $::lsbmajdistrelease == '6' {
    #remove useless gnote package because it blocks newest boost
    if $::host_group == 'nodes' {
      package { 'gnote':
        ensure => absent,
        before => Package['boost'],
      }
    }
    elsif ($::host_group == 'seats') or ($::host_group == 'vagrant') {
      package { 'gnote':
        ensure => absent,
        before => Package['boost-devel'],
      }
    }
  }
}
