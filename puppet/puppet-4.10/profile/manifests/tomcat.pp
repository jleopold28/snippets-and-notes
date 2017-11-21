# Class profile::tomcat
# tomcat profile to be applied to servers that require tomcat installation and configuration
class profile::tomcat(
  String $version = '8.5.23',
  String $download_dir = '/opt/tomcat'
) {
  # setup tomcat binary in $download_dir
  tomcat::install { $download_dir:
    source_url => "https://www-us.apache.org/dist/tomcat/tomcat-${version[0]}/v${version}/bin/apache-tomcat-${version}.tar.gz",
  }

  # verify tomcat binary tarball checksum; due to how puppet works and that the tomcat module implicitly cleans up the tarball, this has to be done with a little cleverness and hackiness
  # collector override use of archive in tomcat to prevent tarball cleanup
  Archive <| title == "${download_dir}-${download_dir}/apache-tomcat-${version}.tar.gz" |> { cleanup => false }

  # download md5sum for tomcat tarball
  file { "${download_dir}/tomcat.md5":
    ensure => file,
    source => "https://www-us.apache.org/dist/tomcat/tomcat-${version[0]}/v${version}/bin/apache-tomcat-${version}.tar.gz.md5",
  }

  # verify tarball checksum
  exec { '/usr/bin/md5sum -c tomcat.md5':
    cwd         => $download_dir,
    subscribe   => [Archive["${download_dir}-${download_dir}/apache-tomcat-${version}.tar.gz"], File["${download_dir}/tomcat.md5"]],
    refreshonly => true,
  }
}
