#!/bin/bash
# *********************************************************
# Usage ./dev.sh {mysql_admin} {admin_password} [{mysql_user}] [{mysql_password}] [{mysql_db}] [{mysql_host}]
# ********************************************************
clear

base_dir=${PWD##*/}
api_conf=api/conf
path_composer=$(which composer)
stored_procs_path=api/data/procedures/*

if [ -x "$path_composer" ] ; then
  echo "Composer found: $path_composer"
else
  echo "Composer not found. Please make sure it is install and within your path to proceed."
  exit 1
fi

# Gather appropriate db credentials
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

echo "Creating database: $mysql_db"
echo "Creating user: $mysql_user"

mysql -u $mysql_admin --password=$admin_password -e "create database $mysql_db" && mysql -u $mysql_admin --password=$admin_password -e "create user '$mysql_user'@'localhost' identified by '$mysql_password'" && mysql -u $mysql_admin --password=$admin_password -e "grant all privileges on $mysql_db.* to '$mysql_user'@'%' identified by '$mysql_password' with grant option";

echo "Creating schema..."
mysql -u $mysql_user --password=$mysql_password $mysql_db < api/data/schema/create_db.sql

echo "Creating stored procedures..."
for file in $stored_procs_path
do
  echo "Processing: $file"
  mysql -u $mysql_user --password=$mysql_password $mysql_db < $file
done

# Generate database configuration for the API to use
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

# Install Slim framework
cd api/
composer install

# Create .htacess file for Slim to work properly
if [ -e .htaccess ]; 
then
    echo "Removing .htaccess"
    rm -f .htaccess
fi

echo "Generating .htaccess"
cat > .htaccess << HTACCESS
  RewriteEngine On

  RewriteBase /$base_dir/
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteRule ^ /$base_dir/index.php [QSA,L]
HTACCESS
