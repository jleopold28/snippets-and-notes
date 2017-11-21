# Class pe_backup::puppet
# performs pe backups using puppet DSL
class pe_backup::puppet {
  # generate time
  $time = strftime('%m_%d_%y_%H_%M')

  # setup backup dirs
  file { ['/var/opt/pe_backups', '/tmp/pe_backup']: ensure => directory }

  file { '/tmp/pg_backup':
    ensure => directory,
    owner  => 'pe-postgres',
  }

  # copy over for backup
  $backups = { '/etc/puppetlabs/puppet' => 'confdir',
    '/etc/puppetlabs/enterprise' => 'enterprise',
    '/etc/puppetlabs/puppetdb/ssl' => 'puppetdb_ssl',
    '/opt/puppetlabs/server/data/console-services/certs' => 'console_certs',
    '/opt/puppetlabs/server/data/postgresql/9.4/data/certs' => 'pg_certs',
    '/etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa' => 'id-control_repo.rsa',
    '/opt/puppetlabs/mcollective/plugins/mcollective' => 'mco_rpc'
  }
  $backups.each |Array[String] $dirs| {
    file { "/tmp/pe_backup/${dirs[1]}":
      ensure  => directory,
      source  => "file:///${dirs[0]}",
      recurse => true,
      require => File['/tmp/pe_backup'],
      notify  => Exec["/bin/tar -cvzf /var/opt/pe_backups/pe_backup_${time}.tar.gz pe_backup; /bin/rm -rf /tmp/pe_backup"],
    }
  }

  # perform pg dumps
  ['activity', 'rbac', 'classifier', 'puppetdb', 'orchestrator'].each |$component| {
    exec { "/opt/puppetlabs/server/bin/pg_dump -Fc pe-${component} -f /tmp/pg_backup/pe-${component}.bin":
      user    => 'pe-postgres',
      creates => "/tmp/pg_backup/pe-${component}.bin",
      require => File['/tmp/pg_backup'],
      notify  => Exec["/bin/tar -cvzf /var/opt/pe_backups/pg_backup_${time}.tar.gz pg_backup; /bin/rm -rf /tmp/pg_backup"],
    }
  }

  # tar up backups and then cleanup tmp dirs
  ['pe', 'pg'].each |$backup| {
    exec { ["/bin/tar -cvzf /var/opt/pe_backups/${backup}_backup_${time}.tar.gz ${backup}_backup; /bin/rm -rf /tmp/${backup}_backup"]:
      cwd         => '/tmp',
      creates     => "/var/opt/pe_backups/${backup}_backup_${time}.tar.gz",
      refreshonly => true,
      require     => File['/var/opt/pe_backups'],
    }
  }
}
