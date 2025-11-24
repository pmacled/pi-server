#!/bin/bash
set -e

echo "Stopping Pi Server services..."

cd uptime-kuma && docker compose --env-file ../.env down && cd ..
cd pihole && docker compose --env-file ../.env down && cd ..
cd portainer && docker compose --env-file ../.env down && cd ..

echo "✅ All services stopped"
