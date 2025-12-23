#!/bin/bash

ENV=$1

echo "Rolling back $ENV..."

docker-compose -f docker-compose.$ENV.yml down
docker-compose -f docker-compose.$ENV.yml up -d

echo "Rollback completed"
