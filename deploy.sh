#!/bin/bash
set -e

echo "Starting deployment..."

docker-compose -f docker-compose.prod.yml down
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d

echo "Waiting for backend health..."

for i in {1..10}; do
  if curl -s http://localhost:8081 | grep "Backend API is running"; then
    echo "Backend is healthy "
    exit 0
  fi
  echo "Waiting... ($i)"
  sleep 3
done

echo "Health check failed after deployment "
docker ps
exit 1
