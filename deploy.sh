#!/bin/bash
# *********************************************************
# Usage ./dev.sh {mysql_admin} {admin_password} [{mysql_user}] [{mysql_password}] [{mysql_db}] [{mysql_host}]
# ********************************************************
clear

current_dir=${PWD##*/}
api_conf=api/conf

if [ -e .htaccess ]; 
then
    echo "Removing .htaccess"
    rm -f .htaccess
fi

echo "Generating .htaccess"
cat > .htaccess << HTACCESS
  RewriteEngine On

  RewriteBase /$current_dir/
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteRule ^ /$current_dir/index.php [QSA,L]
HTACCESS

if [ -z "$1" ]; 
then
    echo -n "MySQL admin user: "
    read mysql_admin
fi

if [ -z "$2" ]; 
then
    echo -n "MySQL admin password: "
    read admin_password
fi

# mysql user
if [ -z "$3" ]; 
then
    read -p "MySQL user [dragon]: " mysql_user
    mysql_user=${mysql_user:-dragon}
fi

# mysql password
if [ -z "$4" ]; 
then
    read -p "MySQL password [password]: " mysql_password
    mysql_password=${mysql_password:-password}
fi

# mysql db
if [ -z "$5" ]; 
then
    read -p "MySQL db [dragon]: " mysql_db
    mysql_db=${mysql_db:-dragon}
fi

if [ -z "$6" ];
then
    read -p "MySQL host [localhost]: " mysql_host
    mysql_host=${mysql_host:-localhost}
fi

mysql -u $mysql_admin --password=$admin_password -e "create database $mysql_db" && mysql -u $mysql_admin --password=$admin_password -e "create user '$mysql_user'@'localhost' identified by '$mysql_password'" && mysql -u $mysql_admin --password=$admin_password -e "grant all privileges on $mysql_db.* to '$mysql_user'@'%' identified by '$mysql_password' with grant option";

mysql -u $mysql_user --password=$mysql_password $mysql_db < api/data/schema/create_db.sql

if [ -e $api_conf/db.conf ];
then
    echo "Removing existing database configuration"
    rm -f $api_conf/db.conf
fi

echo "Generating database configuration"
cat > $api_conf/db.conf << API_CONF
<?php
    define('DB_USER', '$mysql_user');
    define('DB_PASSWORD', '$mysql_password');
    define('DB_DATABASE', '$mysql_db');
    define('DB_HOST', '$mysql_host');
API_CONF

chmod 644 $api_conf/db.conf