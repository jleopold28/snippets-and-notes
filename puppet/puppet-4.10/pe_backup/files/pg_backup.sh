#!/bin/bash
# run as cronjob as pe-postgres

# ensure backup dir exists
/bin/mkdir -p /var/opt/pe_backups
/bin/mkdir -p /tmp/pg_backup

# perform dumps
/opt/puppetlabs/server/bin/pg_dump -Fc pe-activity -f /tmp/pg_backup/pe-activity.bin
/opt/puppetlabs/server/bin/pg_dump -Fc pe-rbac -f /tmp/pg_backup/pe-rbac.bin
/opt/puppetlabs/server/bin/pg_dump -Fc pe-classifier -f /tmp/pg_backup/pe-classifier.bin
/opt/puppetlabs/server/bin/pg_dump -Fc pe-puppetdb -f /tmp/pg_backup/pe-puppetdb.bin
/opt/puppetlabs/server/bin/pg_dump -Fc pe-orchestrator -f /tmp/pg_backup/pe-orchestrator.bin

# tar
/bin/tar -cvzf /var/opt/pe_backups/pg_backup_`date +%m_%d_%y_%H_%M`.tar.gz /tmp/pg_backup

# clean up
/bin/rm -rf /tmp/pg_backup
