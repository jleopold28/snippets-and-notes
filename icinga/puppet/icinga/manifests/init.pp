# main icinga class: geared for icinga, postgres 9.4, and centos 7 on master
# TODO: mariadb, split install (two masters, two db, two satellites), automated web setup options, master versus client
class icinga(
  Boolean $master = false,
  String $icinga_version = '2.5.4'
)
{
  unless $master {
    class { 'icinga::client': icinga_version => $icinga_version }
  }
  else {
    class { 'icinga::base': icinga_version => $icinga_version }
    class { 'icinga::postgresql': }
    class { 'icinga::webserver': }
  }
}
