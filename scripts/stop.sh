#!/bin/bash
set -e

echo "Stopping Pi Server services..."

cd homepage && docker compose --env-file ../.env down && cd ..
cd homeassistant && docker compose --env-file ../.env down && cd ..
cd uptime-kuma && docker compose --env-file ../.env down && cd ..
cd jellyfin && docker compose --env-file ../.env down && cd ..
cd dizquetv && docker compose --env-file ../.env down && cd ..
cd netdata && docker compose --env-file ../.env down && cd ..
cd pihole && docker compose --env-file ../.env down && cd ..
cd portainer && docker compose --env-file ../.env down && cd ..

echo "✅ All services stopped"
