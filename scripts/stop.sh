#!/bin/bash
set -e

echo "Stopping Pi Server services..."

cd uptime-kuma && docker compose down && cd ..
cd pihole && docker compose down && cd ..
cd portainer && docker compose down && cd ..
docker compose down

echo "✅ All services stopped"
