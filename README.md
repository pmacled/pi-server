# Raspberry Pi Server Configuration

## Quick Start

1. Clone this repository
2. Copy `.env.example` to `.env` and edit values
3. Run setup: `./scripts/setup.sh`
4. Deploy services: `./scripts/deploy.sh`

## Services

- Portainer: http://PI_IP:9000
- Pi-hole: http://PI_IP/admin
- Uptime Kuma: http://PI_IP:3001

## Manual Deployment

Deploy individual services:
```bash
cd portainer && docker-compose up -d
cd pihole && docker-compose up -d
cd uptime-kuma && docker-compose up -d
```

## Backup

Pi-hole data is stored in `pihole/etc-pihole/` and `pihole/etc-dnsmasq.d/`
