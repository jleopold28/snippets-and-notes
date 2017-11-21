# Class: pe-backup
# performs automated backups of PE installation
class pe_backup(
  Boolean $scripts = false
) {
  # use scripts with cronjobs for backups
  if $scripts {
    include pe_backup::scripts
  }
  # use puppet resources for backups
  else {
    include pe_backup::puppet
  }
}
