#!/bin/bash
echo "Hello $USER!"
echo "Today is $(date)"
echo "Current working directory : $(pwd)"
echo "Starting deployment..."

# Run container deployments
echo "Running container deployments..."

# Run the docker-compose file
docker compose -f docker-compose.yml up -d --build

# Prune images
echo "Pruning images..."
docker image prune -f

echo "Deployment complete!"
