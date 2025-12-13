# Homepage Configuration

This directory contains Homepage configuration files that are mounted into the Homepage container.

## Files

- **`settings.yaml`** - Global settings (theme, layout, quick launch)
- **`docker.yaml`** - Docker socket configuration for auto-discovery
- **`services.yaml`** - Manual service definitions (mostly empty, services auto-discovered via Docker labels)
- **`bookmarks.yaml`** - Quick links to external sites
- **`widgets.yaml`** - Top bar widgets (greeting, datetime, system resources)

## Auto-Discovery

Services are automatically discovered from Docker containers with `homepage.*` labels. See the docker-compose files in each service directory for examples.

## Customization

Feel free to edit these files to customize your dashboard:
- Change the theme/color in `settings.yaml`
- Add bookmarks to favorite sites in `bookmarks.yaml`
- Modify widget layout in `widgets.yaml`
- Override auto-discovered services in `services.yaml`

## API Keys

Some widgets require API keys (Jellyfin, Home Assistant, etc.). You can:
1. Add them directly to the docker-compose labels
2. Use environment variables in your `.env` file (e.g., `HOMEPAGE_VAR_JELLYFIN_KEY`)

See https://gethomepage.dev for full documentation.
