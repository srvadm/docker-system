FROM php:7.4-fpm-alpine
MAINTAINER Tino Naumann <mail@ti-no.de>

RUN apk add --update-cache tzdata shadow \
  && usermod -u 1000 www-data \
  && groupmod -g 1000 www-data

RUN apk add --update-cache libzip-dev libpng-dev
RUN docker-php-ext-install mysqli \
  && docker-php-ext-install pdo_mysql \
  && docker-php-ext-install gd \
  && docker-php-ext-install zip \
  && rm -rf /var/cache/apk/*
COPY rootfs /
RUN mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
  && rm /usr/local/etc/php/php.ini-development
ENV ENV="/etc/profile"
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm"]