# Martins Portefolie
A Symfony + FrankenPHP-based portfolio site.

## Local Development Setup

```sh
# Build image for development
docker build -t martin_portefolie --build-arg APP_ENV=dev .

# Start container
docker compose up -d

# Install dependencies
docker compose exec martin_portefolie composer install

# Build Tailwind CSS
docker compose exec martin_portefolie bin/console tailwind:build
```


##  Server Setup

```sh
# Build image for production
docker build -t martin_portefolie --build-arg APP_ENV=prod .

# Start container
docker compose up -d

# Install dependencies
docker compose exec martin_portefolie composer install --no-dev --optimize-autoloader

# Dump compiled .env (only needed once after build)
docker compose exec martin_portefolie composer dump-env prod

# Compile frontend assets (Tailwind CSS, etc.)
docker compose exec martin_portefolie bin/console tailwind:build

# Compile asset mapper (images, fonts, etc.)
docker compose exec martin_portefolie bin/console asset-map:compile

```