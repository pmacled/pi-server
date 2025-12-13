#!/bin/bash
set -e

echo "Deploying Pi Server services..."
echo ""

# Check for .env file
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found."
    echo "   Copy .env.example to .env and configure it."
    exit 1
fi

# Check for empty password
source .env
if [ -z "$PIHOLE_PASSWORD" ]; then
    echo "❌ Error: Please set a strong PIHOLE_PASSWORD in .env"
    echo "   Generate one with: openssl rand -base64 32"
    exit 1
fi

# Get IP address (allow override from .env)
if [ -z "$PI_IP" ]; then
    PI_IP=$(hostname -I | awk '{print $1}')
    echo "🔍 Detected IP address: $PI_IP"
    # Add/update PI_IP in .env file
    if grep -q "^PI_IP=" .env; then
        # Update existing PI_IP
        sed -i "s|^PI_IP=.*|PI_IP=$PI_IP|" .env
    else
        # Add PI_IP if not present
        echo "PI_IP=$PI_IP" >> .env
    fi
fi

# Create shared network
echo "📡 Creating shared network..."
docker network create pi-server 2>/dev/null || echo "✅ Network 'pi-server' already exists"

# Deploy services in order
echo ""
echo "🐳 Deploying Portainer..."
cd portainer
docker compose --env-file ../.env up -d
cd ..

echo "🛡️  Deploying Pi-hole..."
cd pihole
docker compose --env-file ../.env up -d
cd ..

echo "📊 Deploying Uptime Kuma..."
cd uptime-kuma
docker compose --env-file ../.env up -d
cd ..

echo "🎬 Deploying Jellyfin..."
cd jellyfin
docker compose --env-file ../.env up -d
cd ..

echo "📺 Deploying dizqueTV..."
cd dizquetv
docker compose --env-file ../.env up -d
cd ..

echo "📈 Deploying Netdata..."
cd netdata
docker compose --env-file ../.env up -d
cd ..

echo "🏠 Deploying Home Assistant..."
cd homeassistant
docker compose --env-file ../.env up -d
cd ..

echo "🏡 Deploying Homepage..."
cd homepage
docker compose --env-file ../.env up -d
cd ..

# Wait for services to start
echo ""
echo "⏳ Waiting for services to become healthy..."
sleep 15

# Show status
echo ""
echo "📋 Service Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "NAMES|homepage|portainer|pihole|uptime-kuma|jellyfin|dizquetv|netdata|homeassistant"

echo ""
echo "✅ Deployment complete!"
echo ""
echo "🌐 Access your services:"
echo "   Homepage:       http://$PI_IP:3000"
echo "   Portainer:      http://$PI_IP:9000"
echo "   Pi-hole:        http://$PI_IP:8080/admin"
echo "   Uptime Kuma:    http://$PI_IP:3001"
echo "   Jellyfin:       http://$PI_IP:8096"
echo "   dizqueTV:       http://$PI_IP:8000"
echo "   Netdata:        http://$PI_IP:19999"
echo "   Home Assistant: http://$PI_IP:8123"
echo ""
echo "⚙️  Next steps:"
echo "   1. Configure Portainer admin account"
echo "   2. Set up Pi-hole (password is in your .env file)"
echo "   3. Configure router DNS to: $PI_IP"
echo "   4. Set up monitoring in Uptime Kuma"
