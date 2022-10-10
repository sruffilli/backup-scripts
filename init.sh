#!/bin/bash
export $(grep -v '^#' .env | xargs -d '\n')
restic init --repo /restic/mikrotik
restic init --repo /restic/quarantanove_configs
restic init --repo /restic/quarantanove_volumes
