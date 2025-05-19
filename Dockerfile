# Dockerfile
FROM dunglas/frankenphp

RUN apt-get update && apt-get install -y \
    libicu-dev \
    unzip \
    git \
    curl \
    zlib1g-dev \
    libzip-dev \
    libpq-dev \
    mariadb-client \
    && docker-php-ext-install intl zip pdo_mysql

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app
COPY . /app

# Default is production, override with --build-arg if needed
ARG APP_ENV=prod
ENV APP_ENV=${APP_ENV}

# Dump optimized .env.local.php in prod
RUN if [ "$APP_ENV" = "prod" ]; then \
        composer install --no-dev --optimize-autoloader && \
        composer dump-env prod; \
    else \
        composer install; \
    fi
