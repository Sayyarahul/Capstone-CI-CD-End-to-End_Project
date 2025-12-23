#!/bin/bash

ENV=$1

if [ "$ENV" == "dev" ]; then PORT=5000; fi
if [ "$ENV" == "staging" ]; then PORT=5001; fi
if [ "$ENV" == "prod" ]; then PORT=5002; fi

echo "Running health check on $ENV..."

STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT/health)

if [ "$STATUS" != "200" ]; then
  echo "Health check failed!"
  exit 1
fi

echo "Health check passed"
