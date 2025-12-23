docker exec db pg_dump appdb > backup.sql

#!/bin/bash

ENV=$1

if [ -z "$ENV" ]; then
  echo "Usage: ./backup.sh <dev|staging|prod>"
  exit 1
fi

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="backups/$ENV"
DB_CONTAINER="db-$ENV"
DB_NAME="appdb_$ENV"
DB_USER="appuser"

echo "Backing up database for $ENV..."

docker exec $DB_CONTAINER \
  pg_dump -U $DB_USER $DB_NAME \
  > $BACKUP_DIR/db_backup_$TIMESTAMP.sql

echo "Backup saved to $BACKUP_DIR/db_backup_$TIMESTAMP.sql"
