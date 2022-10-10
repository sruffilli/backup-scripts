#!/bin/bash
CURRENT_PATH=$(dirname "$0")
#VERBOSITY="--verbose" 
VERBOSITY="--quiet" 

do_prune () {
  do_do_prune $1 $2
  STATUS=$?
  if [ $STATUS -ne 0 ]; then
    echo "!!! Error trying to backup $2 to $1"
    exit $STATUS
  fi
}

do_do_prune () {
  RESTIC_REPO=$1
  echo "*** $(date -u) Running prune on $RESTIC_REPO"
  restic -r $RESTIC_REPOBASEPATH/$RESTIC_REPO prune $VERBOSITY
}

export $(grep -v '^#' $CURRENT_PATH/.env | xargs -d '\n')

do_prune mikrotik             /backups/mikrotik
do_prune quarantanove_configs $DOCKER_BASE_PATH/configs
do_prune quarantanove_volumes $DOCKER_BASE_PATH/volumes