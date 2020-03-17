#!/bin/sh

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

cat << "EOF" | php --
<?php
$connected = false;
while(!$connected) {
  try{
    $dbh = new pdo( 
      'mysql:host=mysql:3306;dbname=$_SERVER["mysql_db"]', '$_SERVER["mysql_user"]', '$_SERVER["mysql_pw"]',
      array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION)
    );
    $connected = true;
  }
  catch(PDOException $ex){
    error_log("Could not connect to MySQL");
    error_log($ex->getMessage());
    error_log("Waiting for MySQL Connection.");
    sleep(5);
  }
}
EOF

"$@"
