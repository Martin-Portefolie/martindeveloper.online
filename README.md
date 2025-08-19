# Martins Portefolie

A small **portfolio site** built with **Symfony 7 + FrankenPHP (Caddy)**.  
Runs in Docker for easy local development and production deployment (behind Traefik).

---

## Development (local)

**Requirements:** Docker + Docker Compose.

```bash
# Start dev stack (exposes http://localhost:8080)
docker compose up -d

# Install PHP deps
docker compose exec app composer install

# Frontend assets (Stimulus/Turbo via importmap + Tailwind)
docker compose exec app php bin/console importmap:install --no-interaction
docker compose exec app bin/console tailwind:build

# Open:
# http://localhost:8080
```

---

## Production (server)

**Assumes:**
- DNS for your domain points to the server
- Traefik v3 is already running on the host and your app service is attached to the external `web` network

```bash
# Build & run prod
docker compose -f docker-compose.prod.yml up -d --build

# First-run: install/import assets & warm cache
APP=$(docker compose -f docker-compose.prod.yml ps -q martin_portefolie)
docker exec -it $APP sh -lc '
  php bin/console importmap:install --no-interaction &&
  php bin/console asset-map:compile &&
  php bin/console tailwind:build &&
  php bin/console cache:clear --env=prod
'

# Verify (should be 200 or redirect to /da):
curl -I https://martindeveloper.dk/da
curl -I https://www.martindeveloper.dk/da
```
