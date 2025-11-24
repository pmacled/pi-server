#!/bin/bash
set -e

echo "Deploying services..."

# Check for .env file
if [ ! -f .env ]; then
    echo "Error: .env file not found. Copy .env.example to .env and configure it."
    exit 1
fi

# Deploy each service
cd portainer && docker compose up -d && cd ..
cd uptime-kuma && docker compose up -d && cd ..
cd pihole && docker compose up -d && cd ..

echo "All services deployed!"
echo "Portainer: http://$(hostname -I | awk '{print $1}'):9000"
echo "Pi-hole: http://$(hostname -I | awk '{print $1}')/admin"
echo "Uptime Kuma: http://$(hostname -I | awk '{print $1}'):3001"
