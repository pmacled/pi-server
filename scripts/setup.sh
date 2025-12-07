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

# Check for external storage
echo "Checking for media storage..."
if [ -d "/mnt/media" ]; then
    echo "External media storage found at /mnt/media"
else
    echo "No external storage found at /mnt/media"
    echo ""
    echo "📀 SSD SETUP REQUIRED:"
    echo "To set up an external SSD for media storage:"
    echo "1. Connect your SSD to the Pi"
    echo "2. Run: sudo fdisk -l (find your drive, e.g., /dev/sda)"
    echo "3. Format: sudo mkfs.ext4 /dev/sda1"
    echo "4. Create mount point: sudo mkdir -p /mnt/media"
    echo "5. Mount: sudo mount /dev/sda1 /mnt/media"
    echo "6. Auto-mount: echo '/dev/sda1 /mnt/media ext4 defaults 0 2' | sudo tee -a /etc/fstab"
    echo "7. Create directories: sudo mkdir -p /mnt/media/{movies,tv,music}"
    echo "8. Set permissions: sudo chown -R $USER:$USER /mnt/media"
    echo ""
fi

echo ""
echo "Setup complete!"
echo "Next steps:"
echo "1. Copy .env.example to .env: cp .env.example .env"
echo "2. Edit .env and set your values: nano .env"
echo "3. Generate a strong password: openssl rand -base64 32"
echo "4. Set up SSD storage if not already done"
echo "5. Run deployment: ./scripts/deploy.sh"
