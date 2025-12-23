#!/bin/bash

ENV=$1

if [ -z "$ENV" ]; then
  echo "Usage: ./collect_logs.sh <dev|staging|prod>"
  exit 1
fi

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_DIR="logs/$ENV"

echo "Collecting logs for $ENV environment..."

docker-compose -f docker-compose.$ENV.yml logs --timestamps \
  > $LOG_DIR/app_$TIMESTAMP.log

echo "Logs saved to $LOG_DIR/app_$TIMESTAMP.log"
