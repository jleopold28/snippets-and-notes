# Class pe_backup::scripts
# performs pe_backups using scripts and cron
class pe_backup::scripts {
  # copy over backup scripts
  file { '/etc/puppetlabs/puppetserver/pe_backup.sh':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0770',
    source => "puppet:///modules/${module_name}/pe_backup.sh",
  }

  # configure cronjobs for backups
  cron { 'pe_backup':
    command => '/bin/sh /etc/puppetlabs/puppetserver/pe_backup.sh',
    user    => 'root',
    minute  => '0',
    require => File['/etc/puppetlabs/puppetserver/pe_backup.sh'],
  }

  # alternative for scheduling script backups with puppet instead of cron
  # schedule { 'custom':
  #   period => daily,
  #   range  => '22-6',
  # }
  # pe_backup::script { 'pe_backup.sh': schedule => 'custom' }
}
