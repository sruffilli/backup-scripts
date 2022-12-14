#!/bin/bash
CURRENT_PATH=$(dirname "$0")
#VERBOSITY="--verbose" 
VERBOSITY="--quiet" 

export $(grep -v '^#' $CURRENT_PATH/.env | xargs -d '\n')

do_prune () {
  _do_prune $*
  RESTIC_BACKEND=$1
  RESTIC_REPO=$2
  DIR_TO_BACKUP=$3
  STATUS=$?
  if [ $STATUS -ne 0 ]; then
    echo "!!! Error trying to prune $RESTIC_BACKEND/$RESTIC_REPO"
    exit $STATUS
  fi
}

_do_prune () {(set -e 
  RESTIC_BACKEND=$1
  RESTIC_REPO=$2
  DIR_TO_BACKUP=$3
  echo "*** $(date -u) Running prune on $RESTIC_BACKEND/$RESTIC_REPO"
  restic -r $RESTIC_BACKEND/$RESTIC_REPO prune $VERBOSITY
)}


# Read the configured repository basepaths from env variable RESTIC_BACKENDS
IFS=',' read -ra RESTIC_REPOSITORIES <<< "$RESTIC_BACKENDS"
# For each base repository...
for REPO in "${RESTIC_REPOSITORIES[@]}"; do
  # ... and for each directory in config.cfg
  for LINE in `grep -v -E "^#|^\\s*$" $CURRENT_PATH/config.cfg` ; do
    IFS="," read -ra REPO_CONFIG <<< "$LINE"
    do_prune $REPO ${REPO_CONFIG[0]} ${REPO_CONFIG[1]}
  done  
done