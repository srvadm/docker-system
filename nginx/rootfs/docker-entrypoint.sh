#!/bin/sh

set -o errexit
set -o pipefail
set -o nounset

if [ -z ${DOMAIN-} ]; then
  echo you need to define a domain
  exit 1
fi

mkdir -p                            \
  /var/www/html/public/             \
  /var/www/logs/nginx/              \
  /var/www/configs/nginx/           \
&& touch                            \
  /var/www/configs/nginx/mail.conf  \
  /var/www/configs/nginx/host.conf  \
&& chown 1000:1000                  \
  /var/www/html/public/             \
  /var/www/logs/nginx/              \
  /var/www/configs/nginx/           \
  /var/www/configs/nginx/mail.conf  \
  /var/www/configs/nginx/host.conf

if ! [ -z ${PHP_HOST-} ] && ! [ -z ${PHP_PORT-} ]; then
  while ! [ $(nc -z $PHP_HOST $PHP_PORT; echo $?) -eq 0 ]
  do
    echo "Waiting for $PHP_HOST Connection."
    sleep 5
  done
fi

"$@"
