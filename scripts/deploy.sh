#!/bin/bash

ENV=$1

echo "Deploying to $ENV..."

docker-compose -f docker-compose.$ENV.yml pull
docker-compose -f docker-compose.$ENV.yml down
docker-compose -f docker-compose.$ENV.yml up -d

./scripts/migrate.sh $ENV
./scripts/health_check.sh $ENV

echo "$ENV deployment completed"
