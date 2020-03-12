#!/bin/sh

mkdir -p /var/www/html/public /var/www/logs/nginx /var/www/configs/nginx
touch /var/www/configs/nginx/host.conf
chown 1000:1000 /var/www/configs/nginx/ /var/www/logs/nginx/

"$@"