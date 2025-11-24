#!/bin/bash
set -e

echo "Setting up Raspberry Pi server..."

# Update system
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -sSL https://get.docker.com | sh
    sudo usermod -aG docker $USER
    sudo systemctl enable docker
    echo "Docker installed. Please log out and back in, then run this script again."
    exit 0
fi

# Install Docker Compose plugin if not present
if ! docker compose version &> /dev/null; then
    echo "Installing Docker Compose plugin..."
    sudo apt install -y docker-compose-plugin
fi

# Create Pi-hole directories
echo "Creating Pi-hole directories..."
mkdir -p pihole/etc-pihole pihole/etc-dnsmasq.d

echo ""
echo "Setup complete!"
echo "Next steps:"
echo "1. Copy .env.example to .env: cp .env.example .env"
echo "2. Edit .env and set your values: nano .env"
echo "3. Generate a strong password: openssl rand -base64 32"
echo "4. Run deployment: ./scripts/deploy.sh"
