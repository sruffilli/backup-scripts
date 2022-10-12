# Backup-scripts

This is a collection of scripts I'm using for remote backups.
It leverages [`restic`](https://github.com/restic/restic) and some ugly bash-glue to make it easy to use and extend.

The backup strategy consists of different **storage backends** (e.g. local paths, GCS buckets, Google Drive folders, ...), each containing multiple **repositories** which holds all the backups for a single **backup folder**.

This implies that when multiple storage backends are defined, each will hold an independent backup of all the folders in scope.

## Setup

If using anything different from local filesystem for your storage backends, make sure the storage destination exists and is properly configured (e.g. for [GCS](https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html#google-cloud-storage)). Repository initialisation is covered below.

### .env file

`.env` contains the base configuration for the system.

`RESTIC_BACKENDS` a comma-separated list of storage backends used for backups

`RESTIC_PASSWORD` is the passphrase used to encrypt/decrypt data

`GOOGLE_PROJECT_ID` and `GOOGLE_APPLICATION_CREDENTIALS` are only required when using GCS as a storage backend. Refer to the [official documentation](https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html#google-cloud-storage) for more details.

Create your own `.env` file by copying the provided sample, and update as required.

```bash
cp .env.sample .env
```


### config.cfg

`config.cfg` contains a comma-separated list of directories to backup, and their repository name.

A typical `config.cfg` file looks like the one below:

```bash
foo:/backups/foo
bar:/mnt/bar
```

where `foo` is the repository name, and `/backups/foo` is the local folder to backup.

### Initialise your repository(es)

The first time (only!) run

```bash
bash init-repos.sh
```

## Helper scripts

`.sh` files in the `./scripts` directory will be executed to perform ad-hoc before the backup starts. This comes handy e.g. for database dumps.


## Crontab 
Two operations can be added to crontab: 

```crontab
# Run backup scripts every day at 1AM
0 1 * * * bash /path/to/backup-scripts/backup.sh
# Run prune scripts every week at 4AM
0 4 * * 1 bash /path/to/backup-scripts/prune.sh
``` 
