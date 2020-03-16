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


VOLUME ["/var/www"]
USER www-data:www-data
RUN mkdir -p /var/www/html/public /var/www/logs/php /var/www/configs/php /var/www/bin/.composer \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/var/www/bin --filename=composer

ENV PATH /var/www/bin:$PATH
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm"]