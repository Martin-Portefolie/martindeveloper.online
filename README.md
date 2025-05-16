# Martins Portefolie
A Symfony + FrankenPHP-based portfolio site.

## 🧪 Local Development Setup

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


##  Local Development Setup

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