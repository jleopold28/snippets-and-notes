# main icinga class: geared for icinga, postgres 9.4, and centos 7
# TODO: mariadb, split install, automated web setup options
class icinga {
  class { 'icinga::base': }
  class { 'icinga::postgresql': }
  class { 'icinga::webserver': }
}
