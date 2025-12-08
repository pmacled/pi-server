#!/bin/bash
set -e

echo "Updating Pi Server services..."

# Pull latest images
cd portainer && docker compose --env-file ../.env pull && cd ..
cd pihole && docker compose --env-file ../.env pull && cd ..
cd uptime-kuma && docker compose --env-file ../.env pull && cd ..
cd jellyfin && docker compose --env-file ../.env pull && cd ..
cd netdata && docker compose --env-file ../.env pull && cd ..

# Restart with new images
./deploy.sh

echo "✅ All services updated"
