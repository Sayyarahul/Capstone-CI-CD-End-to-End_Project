#!/bin/bash

echo "===================================="
echo " Rolling back to previous version..."
echo "===================================="

# Stop current containers
docker compose -f docker-compose.prod.yml down

# Restore previous images
docker tag rahulsayya/capstone-backend:previous rahulsayya/capstone-backend:latest
docker tag rahulsayya/capstone-frontend:previous rahulsayya/capstone-frontend:latest

# Start containers again
docker compose -f docker-compose.prod.yml up -d

echo "===================================="
echo " Rollback completed successfully!"
echo "===================================="
