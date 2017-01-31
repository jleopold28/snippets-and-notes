# main icinga class: geared for icinga, postgres 9.4, and centos 7 on master
# TODO: mariadb, split install (two masters, split db), automated web setup options, satellites, external resources for client auto join/config
class icinga(
  Boolean $master = false,
  String $icinga_version = '2.5.4',
  String $master_fqdn = undef
)
{
  unless $master {
    class { 'icinga::client':
      icinga_version => $icinga_version,
      master_fqdn    => $master_fqdn,
    }
  }
  else {
    class { 'icinga::base': icinga_version => $icinga_version }
    class { 'icinga::postgresql': }
    class { 'icinga::webserver': }
  }
}
