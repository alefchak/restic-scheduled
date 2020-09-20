#!/bin/sh

set -eu

{
    echo "$CRON_BACKUP_EXPRESSION supervisorctl start restic_backup";
    echo "$CRON_CLEANUP_EXPRESSION supervisorctl start restic_cleanup";
} | crontab -

/usr/sbin/crond -f -L /dev/stdout
