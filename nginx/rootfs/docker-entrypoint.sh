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
  /var/www/configs/nginx/host.conf  \
  /var/www/configs/nginx/mail.conf  \
&& chown 1000:1000                  \
  /var/www/html/public/             \
  /var/www/logs/nginx/              \
  /var/www/configs/nginx/           \
  /var/www/configs/nginx/host.conf

if [ -z ${WWW_ROOT-} ]; then
  WWW_ROOT=/var/www/html/public
fi

cat << EOF > /var/www/configs/nginx/host.conf
  root        $WWW_ROOT;
EOF

if ! [ -z ${PHP_HOST-} ] && ! [ -z ${PHP_PORT-} ]; then
  cat << EOF >> /var/www/configs/nginx/host.conf
  location ~ \.php\$ {
    # regex to split \$uri to \$fastcgi_script_name and \$fastcgi_path
    fastcgi_split_path_info ^(.+\.php)(/.+)\$;
    # Check that the PHP script exists before passing it
    try_files       \$fastcgi_script_name  =404;

    # Bypass the fact that try_files resets \$fastcgi_path_info
    # see: http://trac.nginx.org/nginx/ticket/321
    set             \$path_info            \$fastcgi_path_info;
    fastcgi_param   PATH_INFO             \$path_info;

    fastcgi_index   index.php;
    fastcgi_param   SCRIPT_FILENAME       \$document_root\$fastcgi_script_name;
    fastcgi_param   QUERY_STRING          \$query_string;
    fastcgi_param   REQUEST_METHOD        \$request_method;
    fastcgi_param   CONTENT_TYPE          \$content_type;
    fastcgi_param   CONTENT_LENGTH        \$content_length;

    fastcgi_param   SCRIPT_NAME           \$fastcgi_script_name;
    fastcgi_param   REQUEST_URI           \$request_uri;
    fastcgi_param   DOCUMENT_URI          \$document_uri;
    fastcgi_param   DOCUMENT_ROOT         \$document_root;
    fastcgi_param   SERVER_PROTOCOL       \$server_protocol;
    fastcgi_param   REQUEST_SCHEME        \$scheme;
    fastcgi_param   HTTPS                 \$https if_not_empty;

    fastcgi_param   GATEWAY_INTERFACE     CGI/1.1;
    fastcgi_param   SERVER_SOFTWARE       nginx/\$nginx_version;

    fastcgi_param   REMOTE_ADDR           \$remote_addr;
    fastcgi_param   REMOTE_PORT           \$remote_port;
    fastcgi_param   SERVER_ADDR           \$server_addr;
    fastcgi_param   SERVER_PORT           \$server_port;
    fastcgi_param   SERVER_NAME           \$server_name;

    # PHP only, required if PHP was built with --enable-force-cgi-redirect
    fastcgi_param   REDIRECT_STATUS       200;

    # With php-cgi (or other tcp sockets):
    fastcgi_pass    $PHP_HOST:PHP_PORT;
  }
EOF

while ! [ $(nc -z $PHP_HOST $PHP_PORT; echo $?) -eq 0 ]
do
  echo "Waiting for $PHP_HOST Connection."
  sleep 5
done

fi


"$@"
