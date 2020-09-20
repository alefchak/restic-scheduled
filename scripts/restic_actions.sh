#!/bin/sh

echo "Started at $(date)"

start=$(date +%s)
case "$1" in
    backup)
        (set -x; cd /backup; restic backup $RESTIC_BACKUP_OPTIONS .)
        ;;
    cleanup)
        (set -x; \
        restic forget \
            --keep-daily $KEEP_DAILY_SNAPSHOTS \
            --keep-weekly $KEEP_WEEKLY_SNAPSHOTS \
            --keep-monthly $KEEP_MONTHLY_SNAPSHOTS \
            --keep-yearly $KEEP_YEARLY_SNAPSHOTS \
            $RESTIC_FORGET_OPTIONS)
        ;;
    *)
        echo "Usage: $0 {backup|cleanup}"
        exit 1
esac

rc=$?
end=$(date +%s)
echo "Process finished in $((end-start)) seconds"

if [[ $rc == 0 ]]; then
    echo "Command successful!"
else
    echo "Command failed! Exit code was $rc"
    restic unlock
fi

echo "Finished at $(date)"
