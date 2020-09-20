ARG RESTIC_VERSION=latest
FROM restic/restic:$RESTIC_VERSION as base

FROM alpine:3
COPY --from=base /usr/bin/restic /usr/bin/restic

RUN set -eux; \
    apk --update add --no-cache ca-certificates supervisor fuse; \
    mkdir -p /var/log/supervisor

COPY supervisor_restic.ini /etc/supervisor.d/
COPY scripts/* /usr/bin/

VOLUME /backup /config /cache

ENV KEEP_DAILY_SNAPSHOTS 14
ENV KEEP_WEEKLY_SNAPSHOTS 5
ENV KEEP_MONTHLY_SNAPSHOTS 12
ENV KEEP_YEARLY_SNAPSHOTS 100
ENV RESTIC_FORGET_OPTIONS "--prune"
ENV RESTIC_CACHE_DIR /cache

ENV CRON_BACKUP_EXPRESSION "15 0 * * *"
ENV CRON_CLEANUP_EXPRESSION "0 0 * * *"

ENTRYPOINT ["supervisord"]
CMD ["-c", "/etc/supervisord.conf"]
