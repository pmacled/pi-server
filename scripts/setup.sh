#!/bin/bash
set -e

echo "Setting up Raspberry Pi server..."

# Update system
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

echo "Setup complete!"
