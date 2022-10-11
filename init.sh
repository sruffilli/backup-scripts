#!/bin/bash
export $(grep -v '^#' $CURRENT_PATH/.env | xargs -d '\n')
restic init --repo $RESTIC_REPOBASEPATH/mikrotik
restic init --repo $RESTIC_REPOBASEPATH/quarantanove_configs
restic init --repo $RESTIC_REPOBASEPATH/quarantanove_volumes
