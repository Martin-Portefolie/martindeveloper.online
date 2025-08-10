FROM dunglas/frankenphp:latest
WORKDIR /app
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN install-php-extensions intl zip opcache
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

ARG APP_ENV=prod
ENV APP_ENV=${APP_ENV}

# deps first (no scripts yet)
COPY composer.json composer.lock symfony.lock* ./
RUN if [ "$APP_ENV" = "prod" ]; then \
      composer install --no-dev --no-interaction --no-progress --prefer-dist --no-scripts ; \
    else \
      composer install --no-interaction --no-progress --prefer-dist --no-scripts || true ; \
    fi

# now copy app and run scripts
COPY . /app
COPY Caddyfile /etc/frankenphp/Caddyfile
RUN if [ "$APP_ENV" = "prod" ]; then \
      composer install --no-dev --no-interaction --no-progress --prefer-dist && \
      composer dump-env prod && \
      php bin/console asset-map:compile || true && \
      php bin/console tailwind:build || true ; \
    else \
      composer install --no-interaction --no-progress --prefer-dist || true ; \
    fi \
 && chown -R www-data:www-data var

EXPOSE 80
