#!/bin/bash
CURRENT_PATH=$(dirname "$0")
export $(grep -v '^#' $CURRENT_PATH/.env | xargs -d '\n')

IFS=',' read -ra RESTIC_REPOSITORIES <<< "$RESTIC_BACKENDS"
for REPO in "${RESTIC_REPOSITORIES[@]}"; do
  for LINE in `grep -v -E "^#|^\\s*$" $CURRENT_PATH/config.cfg` ; do
    IFS="," read -ra REPO_CONFIG <<< "$LINE"
    restic init --repo $REPO/${REPO_CONFIG[0]}
  done
done