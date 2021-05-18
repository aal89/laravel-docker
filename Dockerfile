FROM php:7.3-alpine

# Install dev dependencies
RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        curl-dev \
        imagemagick-dev \
        libtool \
        libxml2-dev \
        postgresql-dev \
        zlib-dev \
        libzip-dev \
        libjpeg-turbo-dev \
        bash \
        curl \
        g++ \
        gcc \
        git \
        libc-dev \
        libpng-dev \
        make \
    && apk add --no-cache --virtual .some-deps \
        imagemagick \
        postgresql-libs \
        libzip \
    && pecl install \
        imagick \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure exif \
    && docker-php-ext-install \
        curl \
        iconv \
        mbstring \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pcntl \
        tokenizer \
        xml \
        gd \
        zip \
        bcmath \
        exif \
    && docker-php-ext-enable imagick \
    && docker-php-ext-enable exif \
    && apk del -f .build-deps

# Copy production php.ini into container
COPY php.ini $PHP_INI_DIR/php.ini

# Install composer
ENV COMPOSER_HOME /composer
ENV PATH ./vendor/bin:/composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# Setup cronjob to be executed every minute
RUN crontab -l | { cat; echo "* * * * * cd /var/www && php artisan schedule:run >> /dev/null 2>&1"; } | crontab -

# Setup working directory
WORKDIR /var/www

# Default -- easy overridable -- starting CMD
CMD crond && php artisan serve --host=0.0.0.0 --port=8189

# Expose port used by default CMD
EXPOSE 8189
