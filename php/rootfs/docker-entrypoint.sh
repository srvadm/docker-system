#!/bin/sh

mkdir -p /var/www/html/public /var/www/logs/php /var/www/configs/php
chown 1000:1000 /var/www/configs/php/ /var/www/logs/php/

if ! [ -f "/var/www/bin/composer" ]; then
  mkdir -p /var/www/bin/.composer
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/var/www/bin --filename=composer
else
  php /var/www/bin/composer self-update
fi
export PATH=/var/www/bin:$PATH
#if ! [ -f "/var/www/bin/.composer/vendor/bin/wireshell" ]; then
#  php -d memory_limit=-1 /var/www/bin/composer global require wireshell/wireshell -d /var/www/bin/.composer/
#  ln -s /var/www/bin/.composer/vendor/bin/wireshell /var/www/bin/wireshell
#else
#  php /var/www/bin/composer update wireshell/wireshell -d /var/www/bin/.composer/
#fi

if [ -z ${mysql_user-} ]; then
  echo you need to define a mysql user
  exit 1
fi
if [ -z ${mysql_pw-} ]; then
  echo you need to define a mysql user password
  exit 1
fi
if [ -z ${mysql_db-} ]; then
  echo you need to define a mysql database
  exit 1
fi
if [ -z ${pw_user-} ]; then
  # check for requirements (min 2 chars & only letters, "0-9", "-", "_")
  echo you need to define a processwire user
  exit 1
fi
if [ -z ${pw_pwd-} ]; then
  # check for passwordrequirements (min 6 chars)
  echo you need to define a processwire user-password
  exit 1
fi
if [ -z ${pw_email-} ]; then
  # check for correct email format
  echo you need to define a processwire user-email
  exit 1
fi
if [ -z ${domain-} ]; then
  # check for correct domain format
  echo you need to define a processwire domain
  exit 1
fi
if [ -z ${TZ-} ]; then
  # check for correct timezone format
  echo you need to define a timezone
  exit 1
fi

mkdir -p /var/www/html/tmp/

cat << EOF > /var/www/html/tmp/wait_for_mysql.php
<?php
\$connected = false;
while(!\$connected) {
    try{
        \$dbh = new pdo( 
            'mysql:host=mysql:3306;dbname=$mysql_db', '$mysql_user', '$mysql_pw',
            array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION)
        );
        \$connected = true;
    }
    catch(PDOException \$ex){
//        error_log("Could not connect to MySQL");
//        error_log(\$ex->getMessage());
//        error_log("Waiting for MySQL Connection.");
        sleep(5);
    }
}
EOF
php /var/www/html/tmp/wait_for_mysql.php

if ! [ -n "$(ls -A /var/www/html/public/)" ]; then
  /var/www/bin/composer create-project processwire/processwire public -d /var/www/html/
#  curl -sSL https://github.com/processwire/processwire/archive/master.zip -o /var/www/html/tmp/pw.zip
#  /var/www/bin/wireshell new --dbUser $mysql_user --dbPass $mysql_pw --dbName $mysql_db --dbHost mysql --dbEngine=InnoDB --dbCharset=utf8mb4 --timezone $TZ --username $pw_user --userpass $pw_pwd --useremail $pw_email --profile regular --src /var/www/html/tmp/pw.zip --adminUrl admin --httpHosts $domain /var/www/html/public/
  curl -sSL https://www.adminer.org/latest-mysql.php -o /var/www/html/public/db.php
  curl -sSL https://raw.githubusercontent.com/vrana/adminer/master/designs/pepa-linha/adminer.css -o /var/www/html/public/adminer.css
  chown 1000:1000 -R /var/www/html/public/
fi
rm -r /var/www/html/tmp/

"$@"
