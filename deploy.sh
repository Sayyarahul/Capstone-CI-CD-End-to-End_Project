#!/bin/bash
set -e

echo " Starting deployment..."

docker compose -f docker-compose.prod.yml pull
docker compose -f docker-compose.prod.yml down
docker compose -f docker-compose.prod.yml up -d

echo " Checking backend health..."

for i in {1..10}; do
  if curl -sf http://localhost:8081/health; then
    echo " Deployment successful"
    exit 0
  fi
  sleep 3
done

echo " Health check failed after deployment."
./scripts/rollback.sh
exit 1
