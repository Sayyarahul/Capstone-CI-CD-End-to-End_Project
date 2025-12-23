#!/bin/bash

ENV=$1

if [ -z "$ENV" ]; then
  echo "Usage: ./migrate.sh <dev|staging|prod>"
  exit 1
fi

DB_CONTAINER="db-$ENV"
DB_NAME="appdb_$ENV"
DB_USER="appuser"

echo "Running DB migration for $ENV..."

docker exec -i $DB_CONTAINER \
  psql -U $DB_USER $DB_NAME < db/init.sql

echo "Migration completed for $ENV"
