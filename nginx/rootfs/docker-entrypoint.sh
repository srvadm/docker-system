#!/bin/sh

mkdir -p /var/www/html/public /var/www/logs/nginx /var/www/configs/nginx
#touch /var/www/configs/nginx/host.conf
cat << "EOF" > /var/www/configs/nginx/host.conf
	# Block access to ProcessWire system files
	location ~ \.(inc|info|module|sh|sql)$ {
		deny all;
	}

	# Block access to any file or directory that begins with a period
	location ~ /\. {
		deny all;
	}

	# Block access to protected assets directories
	location ~ ^/(site|site-[^/]+)/assets/(cache|logs|backups|sessions|config|install|tmp)($|/.*$) {
		deny all;
	}

	# Block acceess to the /site/install/ directory
	location ~ ^/(site|site-[^/]+)/install($|/.*$) {
		deny all;
	}

	# Block dirs in /site/assets/ dirs that start with a hyphen
	location ~ ^/(site|site-[^/]+)/assets.*/-.+/.* {
		deny all;
	}

	# Block access to /wire/config.php, /site/config.php, /site/config-dev.php, and /wire/index.config.php
	location ~ ^/(wire|site|site-[^/]+)/(config|index\.config|config-dev)\.php$ {
		deny all;
	}

	# Block access to any PHP-based files in /templates-admin/
	location ~ ^/(wire|site|site-[^/]+)/templates-admin($|/|/.*\.(php|html?|tpl|inc))$ {
		deny all;
	}

	# Block access to any PHP or markup files in /site/templates/
	location ~ ^/(site|site-[^/]+)/templates($|/|/.*\.(php|html?|tpl|inc))$ {
		deny all;
	}

	# Block access to any PHP files in /site/assets/
	location ~ ^/(site|site-[^/]+)/assets($|/|/.*\.php)$ {
		deny all;
	}

	# Block access to any PHP files in core or core module directories
	location ~ ^/wire/(core|modules)/.*\.(php|inc|tpl|module)$ {
		deny all;
	}

	# Block access to any PHP files in /site/modules/
	location ~ ^/(site|site-[^/]+)/modules/.*\.(php|inc|tpl|module)$ {
		deny all;
	}

	# Block access to any software identifying txt files
	location ~ ^/(COPYRIGHT|INSTALL|README|htaccess)\.(txt|md)$ {
		deny all;
	}

	location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|eot|woff|ttf)$ {
		expires 24h;
		log_not_found off;
		access_log off;
		try_files $uri $uri/ /index.php?it=$uri&$args;
	}

#	location / {
#		try_files $uri $uri/ /index.php?it=$uri&$args;
#	}

	location /doc/ {
		deny all;
	}
EOF
chown 1000:1000 -R /var/www/configs/nginx/ /var/www/logs/nginx/

if [ -z ${domain-} ]; then
  echo you need to define a domain
  exit 1
fi

"$@"