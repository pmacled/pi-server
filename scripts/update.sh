#!/bin/bash
set -e

echo "Updating Pi Server services..."

# Pull latest images
cd portainer && docker compose pull && cd ..
cd pihole && docker compose pull && cd ..
cd uptime-kuma && docker compose pull && cd ..

# Restart with new images
./deploy.sh

echo "✅ All services updated"
