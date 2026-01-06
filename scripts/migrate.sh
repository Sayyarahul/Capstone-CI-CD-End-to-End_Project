#!/bin/bash

ENV=$1

if [ -z "$ENV" ]; then
  echo "Usage: ./migrate.sh <dev|staging|prod>"
  exit 1
fi

echo "Running database migrations for environment: $ENV"

# DB container mapping (same DB for now)
DB_CONTAINER="capstone-db"

echo "Using DB container: $DB_CONTAINER"

POSTGRES_USER=appuser
POSTGRES_DB=appdb

# Ensure schema_migrations table exists
docker exec -i "$DB_CONTAINER" psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" <<EOF
CREATE TABLE IF NOT EXISTS schema_migrations (
  version TEXT PRIMARY KEY,
  applied_at TIMESTAMP DEFAULT NOW()
);
EOF

# Apply migrations
for file in db/migrations/*.sql; do
  version=$(basename "$file")

  echo "Checking migration: $version"

  EXISTS=$(docker exec -i "$DB_CONTAINER" psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -tAc \
    "SELECT 1 FROM schema_migrations WHERE version='$version'")

  if [ "$EXISTS" = "1" ]; then
    echo "Skipping already applied migration: $version"
  else
    echo "Applying migration: $version"
    docker exec -i "$DB_CONTAINER" psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f "$file"

    docker exec -i "$DB_CONTAINER" psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
      -c "INSERT INTO schema_migrations(version) VALUES ('$version');"
  fi
done

echo "Database migrations completed for $ENV"
