#!/bin/bash
CURRENT_PATH=$(dirname "$0")
export $(grep -v '^#' $CURRENT_PATH/.env | xargs -d '\n')

IFS=',' read -ra RESTIC_REPOSITORIES <<< "$RESTIC_REPOBASEPATHS"
for REPO in "${RESTIC_REPOSITORIES[@]}"; do
  restic init --repo $REPO/mikrotik
  restic init --repo $REPO/quarantanove_configs
  restic init --repo $REPO/quarantanove_volumes
done