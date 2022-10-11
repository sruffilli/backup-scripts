#!/bin/bash
CURRENT_PATH=$(dirname "$0")
#VERBOSITY="--verbose" 
VERBOSITY="--quiet" 

export $(grep -v '^#' $CURRENT_PATH/.env | xargs -d '\n')

# for LINE in `grep -v -E "^#|^\\s*$" $CURRENT_PATH/config.cfg` ; do
#   IFS=":" read -ra REPO_CONFIG <<< "$LINE"
#   echo ${REPO_CONFIG[0]} "-->" ${REPO_CONFIG[1]}
# done

IFS=',' read -ra RESTIC_REPOSITORIES <<< "$RESTIC_REPOBASEPATHS"
for REPO in "${RESTIC_REPOSITORIES[@]}"; do
  for LINE in `grep -v -E "^#|^\\s*$" $CURRENT_PATH/config.cfg` ; do
    IFS=":" read -ra REPO_CONFIG <<< "$LINE"
    echo do_backup $REPO ${REPO_CONFIG[0]} ${REPO_CONFIG[1]}
  done  
done