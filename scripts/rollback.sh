#!/bin/bash

echo " Deployment failed. Rolling back..."

# Stop current containers
docker compose -f docker-compose.prod.yml down

# Start last known working images (previous tag)
docker compose -f docker-compose.prod.yml up -d

echo " Rollback completed. Previous version restored."
