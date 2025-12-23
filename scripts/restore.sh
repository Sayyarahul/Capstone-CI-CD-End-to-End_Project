cat backup.sql | docker exec -i db psql appdb

#!/bin/bash

ENV=$1
BACKUP_FILE=$2

if [ -z "$ENV" ] || [ -z "$BACKUP_FILE" ]; then
  echo "Usage: ./restore.sh <dev|staging|prod> <backup_file.sql>"
  exit 1
fi

DB_CONTAINER="db-$ENV"
DB_NAME="appdb_$ENV"
DB_USER="appuser"

echo "Restoring database for $ENV from $BACKUP_FILE..."

cat $BACKUP_FILE | docker exec -i $DB_CONTAINER \
  psql -U $DB_USER $DB_NAME

echo "Restore completed for $ENV"
