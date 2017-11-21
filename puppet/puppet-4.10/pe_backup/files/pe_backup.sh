#!/bin/bash
# run as cronjob as root

# ensure backup dir exists
/bin/mkdir -p /var/opt/pe_backups
/bin/mkdir -p /tmp/pe_backup
sudo -u pe-postgres /bin/mkdir -p /tmp/pg_backup

# copy over for backup
/bin/cp -a /etc/puppetlabs/puppet /tmp/pe_backup/confdir
/bin/cp -a /etc/puppetlabs/enterprise /tmp/pe_backup/.
/bin/cp -a /etc/puppetlabs/puppetdb/ssl /tmp/pe_backup/puppetdb_ssl
/bin/cp -a /opt/puppetlabs/server/data/console-services/certs /tmp/pe_backup/console_certs
/bin/cp -a /opt/puppetlabs/server/data/postgresql/9.4/data/certs /tmp/pe_backup/pg_certs
/bin/cp -a /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa /tmp/pe_backup/.
/bin/cp -a /opt/puppetlabs/mcollective/plugins /tmp/pe_backup/mco_rpc

# perform dumps
sudo -u pe-postgres /opt/puppetlabs/server/bin/pg_dump -Fc pe-activity -f /tmp/pg_backup/pe-activity.bin
sudo -u pe-postgres /opt/puppetlabs/server/bin/pg_dump -Fc pe-rbac -f /tmp/pg_backup/pe-rbac.bin
sudo -u pe-postgres /opt/puppetlabs/server/bin/pg_dump -Fc pe-classifier -f /tmp/pg_backup/pe-classifier.bin
sudo -u pe-postgres /opt/puppetlabs/server/bin/pg_dump -Fc pe-puppetdb -f /tmp/pg_backup/pe-puppetdb.bin
sudo -u pe-postgres /opt/puppetlabs/server/bin/pg_dump -Fc pe-orchestrator -f /tmp/pg_backup/pe-orchestrator.bin

# tar
/bin/tar -cvzf /var/opt/pe_backups/pe_backup_`date +%m_%d_%y_%H_%M`.tar.gz /tmp/pe_backup
/bin/tar -cvzf /var/opt/pe_backups/pg_backup_`date +%m_%d_%y_%H_%M`.tar.gz /tmp/pg_backup

# clean up
/bin/rm -rf /tmp/p{e,g}_backup
