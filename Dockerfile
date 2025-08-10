# syntax=docker/dockerfile:1
FROM dunglas/frankenphp:latest

WORKDIR /app

# PHP extensions (no DB)
RUN install-php-extensions intl zip opcache

# Composer from official image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Dev by default; override with --build-arg APP_ENV=prod in prod
ARG APP_ENV=dev
ENV APP_ENV=${APP_ENV}

# Use cache for deps
COPY composer.json composer.lock symfony.lock* ./
RUN if [ "$APP_ENV" = "prod" ]; then \
      composer install --no-dev --optimize-autoloader --no-interaction --no-progress; \
    else \
      composer install --no-interaction --no-progress || true; \
    fi

# App (includes Caddyfile with {$SERVER_NAME})
COPY . /app

# Prod-only optimizations
RUN if [ "$APP_ENV" = "prod" ]; then \
      composer dump-env prod && \
      php bin/console asset-map:compile || true && \
      php bin/console tailwind:build || true; \
    fi \
 && chown -R www-data:www-data var

EXPOSE 80
