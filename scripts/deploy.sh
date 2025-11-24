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

# Create shared network
echo "📡 Creating shared network..."
docker compose up -d

# Deploy services in order
echo ""
echo "🐳 Deploying Portainer..."
cd portainer && docker compose up -d && cd ..

echo "🛡️  Deploying Pi-hole..."
cd pihole && docker compose up -d && cd ..

echo "📊 Deploying Uptime Kuma..."
cd uptime-kuma && docker compose up -d && cd ..

# Wait for services to start
echo ""
echo "⏳ Waiting for services to become healthy..."
sleep 15

# Show status
echo ""
echo "📋 Service Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "NAMES|portainer|pihole|uptime-kuma"

# Get IP address
PI_IP=$(hostname -I | awk '{print $1}')

echo ""
echo "✅ Deployment complete!"
echo ""
echo "🌐 Access your services:"
echo "   Portainer:    http://$PI_IP:9000"
echo "   Pi-hole:      http://$PI_IP:8080/admin"
echo "   Uptime Kuma:  http://$PI_IP:3001"
echo ""
echo "⚙️  Next steps:"
echo "   1. Configure Portainer admin account"
echo "   2. Set up Pi-hole (password is in your .env file)"
echo "   3. Configure router DNS to: $PI_IP"
echo "   4. Set up monitoring in Uptime Kuma"
