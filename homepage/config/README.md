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

## Environment Variables

Homepage uses template variables in the format `{{HOMEPAGE_VAR_*}}` that are replaced at runtime. These are set via environment variables in the homepage docker-compose.yml:

- `HOMEPAGE_VAR_PI_IP`: Your Pi's IP address (auto-populated from `PI_IP` in .env)
- `HOMEPAGE_VAR_PIHOLE_KEY`: Pi-hole API key for widget (optional)
- `HOMEPAGE_VAR_HOMEASSISTANT_KEY`: Home Assistant long-lived access token (optional)
- `HOMEPAGE_VAR_JELLYFIN_KEY`: Jellyfin API key for widget (optional)
- `HOMEPAGE_VAR_PORTAINER_KEY`: Portainer API key for widget (optional)

## API Keys Setup

To enable Homepage widgets with live data:

1. **Add keys to your `.env` file**:
   ```bash
   PIHOLE_API_KEY=your_key_here
   HOMEASSISTANT_API_KEY=your_token_here
   JELLYFIN_API_KEY=your_key_here
   PORTAINER_API_KEY=your_key_here
   ```

2. **How to get API keys**:
   - **Pi-hole**: Settings → API → Show API token
   - **Home Assistant**: Profile → Security → Long-Lived Access Tokens → Create Token
   - **Jellyfin**: Dashboard → Advanced → API Keys → New API Key
   - **Portainer**: Account settings → Access tokens → Add access token

3. **Redeploy Homepage**:
   ```bash
   cd homepage && docker compose down && docker compose up -d
   ```

See https://gethomepage.dev for full documentation.
