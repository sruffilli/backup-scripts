#!/bin/bash

DOCKER_BASE_PATH=/home/ruffi/git/quarantanove
FORGET_OPTIONS="--keep-daily 1 --keep-weekly 5 --keep-monthly 12 --keep-yearly 3"

do_backup () {
  do_do_backup $1 $2
  STATUS=$?
  if [ $STATUS -ne 0 ]; then
    echo "!!! Error trying to backup $2 to $1"
    exit $STATUS
  fi
}

do_do_backup () {(set -e 
  RESTIC_REPO=$1
  DIR_TO_BACKUP=$2
  echo "*** $(date -u) Backing up $DIR_TO_BACKUP to $RESTIC_REPO"
  restic -r $RESTIC_REPOBASEPATH/$1 backup $DIR_TO_BACKUP --quiet
  echo "*** $(date -u) Running forget on $RESTIC_REPO"
  restic -r $RESTIC_REPOBASEPATH/$RESTIC_REPO forget $FORGET_OPTIONS --quiet
  echo "*** $(date -u) Running prune on $RESTIC_REPO"
  restic -r $RESTIC_REPOBASEPATH/$RESTIC_REPO prune --quiet
)}

export $(grep -v '^#' .env | xargs -d '\n')

echo "*** $(date -u) Running scripts/*.sh"
for SCRIPT in scripts/*.sh; do
  echo "*** $(date -u) Running $SCRIPT"
  bash "$SCRIPT"
done

do_backup mikrotik             /backups/mikrotik
do_backup quarantanove_configs $DOCKER_BASE_PATH/configs
do_backup quarantanove_volumes $DOCKER_BASE_PATH/volumes