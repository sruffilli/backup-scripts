#!/bin/bash
CURRENT_PATH=$(dirname "$0")
#VERBOSITY="--verbose" 
VERBOSITY="--quiet" 

export $(grep -v '^#' $CURRENT_PATH/.env | xargs -d '\n')

do_prune () {
  _do_prune $*
  RESTIC_BASEPATH=$1
  RESTIC_REPO=$2
  DIR_TO_BACKUP=$3
  STATUS=$?
  if [ $STATUS -ne 0 ]; then
    echo "!!! Error trying to prune $RESTIC_BASEPATH/$RESTIC_REPO"
    exit $STATUS
  fi
}

_do_prune () {(set -e 
  RESTIC_BASEPATH=$1
  RESTIC_REPO=$2
  DIR_TO_BACKUP=$3
  echo "*** $(date -u) Running prune on $RESTIC_BASEPATH/$RESTIC_REPO"
  restic -r $RESTIC_BASEPATH/$RESTIC_REPO prune $VERBOSITY
)}

IFS=',' read -ra RESTIC_REPOSITORIES <<< "$RESTIC_REPOBASEPATHS"
for REPO in "${RESTIC_REPOSITORIES[@]}"; do
  do_prune $REPO mikrotik             /backups/mikrotik
  do_prune $REPO quarantanove_configs $DOCKER_BASE_PATH/configs
  do_prune $REPO quarantanove_volumes $DOCKER_BASE_PATH/volumes
done
