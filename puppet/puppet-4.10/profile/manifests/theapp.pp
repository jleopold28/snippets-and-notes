# Class profile::theapp
# theapp profile to be applied to servers that require theapp stack installation and configuration
class profile::theapp(
  String $tomcat_dir,
  String $tomcat_version,
  String $war,
  String $port,
  String $tomcat_url,
  Boolean $java_devel
) {
  # install and configure java
  case $java_devel {
    true: { class { 'java': distribution => 'jdk' } }
    false: { class { 'java': distribution => 'jre' } }
  }

  # install tomcat
  tomcat::install { $tomcat_dir:
    source_url   => "${tomcat_url}/tomcat-${tomcat_version[0]}/v${tomcat_version}/bin/apache-tomcat-${tomcat_version}.tar.gz",
    user         => 'tomcat',
    group        => 'tomcat',
    manage_user  => true,
    manage_group => true,
    before       => [Tomcat::War[$war], Tomcat::Config::Server::Connector['tomcat']],
  }

  # deploy war file for application
  tomcat::war { $war:
    deployment_path => '/tmp',
    war_source      => "puppet:///modules/profile/${war}",
  }

  file { "${tomcat_dir}/webapps/theapp.war":
    ensure  => file,
    source  => "file:///tmp/${war}",
    require => Tomcat::War[$war],
  }

  # customize tomcat server
  tomcat::config::server::connector { 'tomcat':
    catalina_base         => $tomcat_dir,
    port                  => $port,
    protocol              => 'HTTP/1.1',
    additional_attributes => {
      'redirectPort'      => '8443',
      'connectionTimeout' => '20000'
    },
    server_config         => "${tomcat_dir}/conf/server.xml",
    purge_connectors      => true,
  }

  # start up tomcat instance
  tomcat::instance { 'tomcat':
    catalina_home => $tomcat_dir,
    require       => [File["${tomcat_dir}/webapps/theapp.war"], Tomcat::Config::Server::Connector['tomcat']],
  }

  # disable selinux
  if $facts['selinux'] {
    if $facts['osfamily'] == 'RedHat' {
      class { 'selinux': mode => 'disabled' }
    }
    else {
      file { '/selinux/enforce':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0700',
        content => '0',
      }
    }
  }

  # open firewall for application
  firewall { '100 allow tomcat port access':
    dport  => $port,
    proto  => 'tcp',
    action => 'accept',
  }

  class { 'firewall': ensure => running }
}
