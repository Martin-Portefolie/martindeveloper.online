# --- Base PHP + Caddy (FrankenPHP) ---
FROM dunglas/frankenphp:latest

WORKDIR /app
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN install-php-extensions intl zip opcache

# Composer CLI
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Build-time defaults (can be overridden)
ARG APP_ENV=prod
ARG DATABASE_URL=sqlite:///%kernel.project_dir%/var/data.db
ENV APP_ENV=${APP_ENV} \
    DATABASE_URL=${DATABASE_URL}

# 1) Warm vendor cache (no scripts to avoid cache:clear needing env)
COPY composer.json composer.lock symfony.lock* ./
RUN composer install --no-interaction --no-progress --prefer-dist --no-scripts

# 2) Copy app + Caddyfile
COPY . /app
COPY Caddyfile /etc/frankenphp/Caddyfile

# 3) Finalize per env
RUN if [ "$APP_ENV" = "prod" ]; then \
      composer dump-env prod && \
      composer install --no-dev --no-interaction --no-progress --prefer-dist && \
      php bin/console importmap:install --no-interaction && \
      php bin/console asset-map:compile || true && \
      php bin/console tailwind:build || true && \
      php bin/console cache:clear --env=prod || true ; \
    else \
      composer install --no-interaction --no-progress --prefer-dist || true ; \
    fi \
 && chown -R www-data:www-data var

EXPOSE 80
