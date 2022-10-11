# Backup-scripts

## Setup

If using anything different from local filesystem, make sure the storage destination exists and is properly configured. e.g. [GCS](https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html#google-cloud-storage).
Repository initialisation is covered below.


### .env file

Create your own `.env` file by copying the provided sample.

```bash
cp .env.sample .env
```

Your file will look like the one below:

```bash
RESTIC_REPOBASEPATHS=gs:my-storage-bucket:,/restic
RESTIC_PASSWORD=resticpassword
GOOGLE_PROJECT_ID=mygoogleprojectid
GOOGLE_APPLICATION_CREDENTIALS=/path/to/service_account_credentials.json
```

`GOOGLE_` variables are used for the credentials to write to a GCS bucket. They can be left unset if GCS is not used.

### Initialise your repository(es)

The first time (only!) run

```bash
bash init-repos.sh
```

### Configure helper scripts
STUB

### Configure backup paths
STUB

### Crontab 
STUB