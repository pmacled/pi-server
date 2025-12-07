# Raspberry Pi Server Configuration

Modular Docker setup for Raspberry Pi with Portainer, Pi-hole, and Uptime Kuma.

## Quick Start
```bash
# 1. Clone and setup
git clone https://github.com/pmacled/pi-server.git
cd pi-server
chmod +x scripts/*.sh
./scripts/setup.sh

# 2. Configure
cp .env.example .env
nano .env  # Set TIMEZONE and generate PIHOLE_PASSWORD

# 3. Deploy
./scripts/deploy.sh
```

## Services

| Service | URL | Purpose |
|---------|-----|---------|
| Portainer | `http://PI_IP:9000` | Docker container management |
| Pi-hole | `http://PI_IP:8080/admin` | Network-wide ad blocking |
| Uptime Kuma | `http://PI_IP:3001` | Service monitoring |
| Jellyfin | `http://PI_IP:8096` | Media server for movies, TV shows, and music |

⚠️ **Note**: Pi-hole web interface is on port 8080 (not 80) to avoid conflicts. DNS still uses standard port 53.

## Architecture

- **Shared Network**: All services communicate via `pi-server` Docker network
- **Health Checks**: All services include health monitoring
- **Resource Limits**: Memory limits prevent system overload
- **Modular Design**: Each service in separate directory with own compose file

## Management
```bash
# Deploy all services
./scripts/deploy.sh

# Stop all services
./scripts/stop.sh

# Update all services
./scripts/update.sh

# View logs
docker logs pihole
docker logs portainer
docker logs uptime-kuma
docker logs jellyfin

# Check service health
docker ps --format "table {{.Names}}\t{{.Status}}"
```

## Service Details

### Portainer
- **Image**: `portainer/portainer-ce:2.21.4`
- **Memory**: No limit (minimal usage)
- **Data**: Stored in named volume `portainer_data`

### Pi-hole
- **Image**: `pihole/pihole:2024.07.0`
- **Memory**: 512MB limit
- **Data**: `./pihole/etc-pihole/` and `./pihole/etc-dnsmasq.d/`
- **DNS Port**: 53 (TCP/UDP)
- **Web Port**: 8080

### Uptime Kuma
- **Image**: `louislam/uptime-kuma:1.23.15`
- **Memory**: 256MB limit
- **Data**: Stored in named volume `uptime-kuma_data`

### Jellyfin
- **Image**: `jellyfin/jellyfin:10.10.3`
- **Memory**: 1GB limit
- **Data**: Config and cache in named volumes
- **Media**: Requires SSD mounted at `/mnt/media/`
- **Hardware**: GPU transcoding enabled for Raspberry Pi

## Configuration

### Router DNS Setup
1. Access your router admin panel
2. Set primary DNS to your Pi's IP address
3. Set secondary DNS to 8.8.8.8 (or your ISP's DNS)

### Uptime Kuma Monitors
Suggested monitors to add:
- Pi-hole: `http://pihole:80` (internal network)
- Portainer: `http://portainer:9000`
- Router: `http://192.168.1.1` (adjust to your router IP)
- Internet: `https://1.1.1.1`

## Backup
```bash
# Backup Pi-hole configuration
tar -czf pihole-backup-$(date +%Y%m%d).tar.gz pihole/

# Backup Docker volumes
docker run --rm -v portainer_data:/data -v $(pwd):/backup ubuntu tar czf /backup/portainer-backup-$(date +%Y%m%d).tar.gz -C /data .
docker run --rm -v uptime-kuma_data:/data -v $(pwd):/backup ubuntu tar czf /backup/uptime-kuma-backup-$(date +%Y%m%d).tar.gz -C /data .
```

## Troubleshooting

### Service won't start
```bash
# Check logs
docker logs pihole

# Restart specific service
cd pihole && docker compose restart && cd ..
```

### Port conflicts
```bash
# Check what's using a port
sudo lsof -i :8080
```

### Pi-hole not blocking ads
1. Verify DNS: `nslookup google.com <PI_IP>`
2. Check router DNS settings
3. Clear browser cache
4. Check Pi-hole logs: `docker logs pihole`

## Updates

Services use pinned versions for stability. To update:

1. Edit compose file with new version
2. Run `./scripts/update.sh`

Or use Portainer's web UI to update containers.

## Security Notes

- Pi-hole password is in `.env` (not committed to git)
- Docker socket exposed to Portainer (standard but has security implications)
- All services on same Docker network (isolated from host)
- No services exposed to internet by default

## Repository Structure
```
pi-server-config/
├── README.md                    # This file
├── .env.example                 # Template for configuration
├── .gitignore                   # Excludes sensitive data
├── docker-compose.yml           # Shared network definition
├── pihole/
│   └── docker-compose.yml      # Pi-hole service
├── portainer/
│   └── docker-compose.yml      # Portainer service
├── uptime-kuma/
│   └── docker-compose.yml      # Uptime Kuma service
├── jellyfin/
│   └── docker-compose.yml      # Jellyfin media server
└── scripts/
    ├── setup.sh                 # Initial system setup
    ├── deploy.sh                # Deploy all services
    ├── stop.sh                  # Stop all services
    └── update.sh                # Update all services
```