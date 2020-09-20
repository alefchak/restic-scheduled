#!/bin/sh

cd ${0%/*}

RESTIC_VERSION=${RESTIC_VERSION:-latest}

docker build "${0%/*}" \
  --build-arg RESTIC_VERSION=$RESTIC_VERSION \
  --tag=alefchak/restic-scheduled:$RESTIC_VERSION \
  --tag=alefchak/restic-scheduled:latest