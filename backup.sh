#!/bin/bash
CURRENT_PATH=$(dirname "$0")
DOCKER_BASE_PATH=/home/ruffi/git/quarantanove
FORGET_OPTIONS="--keep-daily 1 --keep-weekly 5 --keep-monthly 12 --keep-yearly 3"
#VERBOSITY="--verbose" 
VERBOSITY="--quiet" 

export $(grep -v '^#' $CURRENT_PATH/.env | xargs -d '\n')

do_backup () {
  _do_backup $*
  RESTIC_BASEPATH=$1
  RESTIC_REPO=$2
  DIR_TO_BACKUP=$3
  STATUS=$?
  if [ $STATUS -ne 0 ]; then
    echo "!!! Error trying to backup $DIR_TO_BACKUP to $RESTIC_BASEPATH/$RESTIC_REPO"
    exit $STATUS
  fi
}

_do_backup () {(set -e 
  RESTIC_BASEPATH=$1
  RESTIC_REPO=$2
  DIR_TO_BACKUP=$3
  echo "*** $(date -u) Backing up $DIR_TO_BACKUP to $RESTIC_BASEPATH/$RESTIC_REPO"
  restic -r $RESTIC_BASEPATH/$RESTIC_REPO backup $DIR_TO_BACKUP $VERBOSITY
  echo "*** $(date -u) Running forget on $RESTIC_BASEPATH/$RESTIC_REPO"
  restic -r $RESTIC_BASEPATH/$RESTIC_REPO forget $FORGET_OPTIONS $VERBOSITY
)}

echo "*** $(date -u) Running scripts/*.sh"
for SCRIPT in $CURRENT_PATH/scripts/*.sh; do
  echo "*** $(date -u) Running $SCRIPT"
  bash "$SCRIPT"
done

# Read the configured repository basepaths from env variable RESTIC_REPOBASEPATHS
IFS=',' read -ra RESTIC_REPOSITORIES <<< "$RESTIC_REPOBASEPATHS"
# For each base repository...
for REPO in "${RESTIC_REPOSITORIES[@]}"; do
  # ... and for each directory in config.cfg
  for LINE in `grep -v -E "^#|^\\s*$" $CURRENT_PATH/config.cfg` ; do
    IFS=":" read -ra REPO_CONFIG <<< "$LINE"
    do_backup $REPO ${REPO_CONFIG[0]} ${REPO_CONFIG[1]}
  done  
done