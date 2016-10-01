class softwaretwo::install() {
  #install necessary softwaretwo packages
  if $::lsbmajdistrelease == '5' {
    if $::host_group == 'nodes' {
      $pkgs = ['omniORB.x86_64', 'vl', 'zlib', 'perl-XML-Simple', 'perl-DBD-SQLite', 'ImageMagick-perl', 'perl-XML-LibXML', 'qwt', 'qwtpolar', 'libqxt', 'gedit', 'xterm', 'wxPython']
    }
    elsif ($::host_group == 'seats') or ($::host_group == 'vagrant') {
      $pkgs = ['omniORB-devel.x86_64', 'vl', 'zlib-devel', 'perl-XML-Simple', 'perl-DBD-SQLite', 'ImageMagick-perl', 'perl-XML-LibXML', 'qwt', 'qwtpolar', 'libqxt', 'gedit', 'xterm', 'wxPython', 'sshpass']
    }
  }
  elsif $::lsbmajdistrelease == '6' {
    if $::host_group == 'nodes' {
      $pkgs = ['qwt-6.0.1', 'qwtpolar', 'libqxt', 'omniORB', 'OpenSceneGraph', 'vl', 'gridengine', 'zlib', 'perl-XML-Simple', 'ImageMagick-perl', 'perl-XML-LibXML', 'perl-DBD-SQLite', 'qt-mysql', 'gedit', 'xterm', 'wxPython', 'qt-property-browser', 'qt-ffmpeg']
    }
    elsif ($::host_group == 'seats') or ($::host_group == 'vagrant') {
      $pkgs = ['qwt-devel-6.0.1', 'qwtpolar-devel', 'libqxt-devel', 'omniORB-devel', 'OpenSceneGraph-devel', 'vl', 'gridengine-devel', 'zlib-devel', 'perl-XML-Simple', 'ImageMagick-perl', 'perl-XML-LibXML', 'perl-DBD-SQLite', 'qt-mysql', 'gedit', 'xterm', 'wxPython', 'qt-property-browser-devel', 'qt-ffmpeg-devel', 'sshpass']
    }
  }

  package { $pkgs: ensure => latest }

  if ($::operatingsystem == 'CentOS') and ($::lsbmajdistrelease == '6') {
    package { 'perl-XML-SAX-0.96':
      ensure => latest,
      before => Package['perl-XML-LibXML'],
    }
  }
}
