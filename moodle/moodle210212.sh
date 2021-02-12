#!/bin/bash
#Korean HUSTOJ installation script
#Made by melongist(what_is_computer@msn.com)
#for Korean

VER_DATE="2021.02.12"

THISFILE="moodle210212.sh"
SRCZIP="moodle210209.zip"

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash ${THISFILE}'"
  exit 1
fi

cd

#for South Korea's timezone
sudo timedatectl set-timezone 'Asia/Seoul'

sudo apt update
sudo apt -y upgrade


sudo apt install -y nginx
sudo systemctl is-enabled nginx

sudo apt install -y mariadb-server mariadb-client
sudo systemctl is-enabled mariadb

sudo mysql_secure_installation

sudo apt install -y php php-mysql php-fpm
sudo systemctl is-enabled php7.4-fpm


sudo sed -i "s:index index.html:index index.php index.html:g" /etc/nginx/sites-enabled/default
sudo sed -i "s:#location ~ \\\.php\\$:location ~ \\\.php\\$:g" /etc/nginx/sites-enabled/default
sudo sed -i "s:#\tinclude snippets:\tinclude snippets:g" /etc/nginx/sites-enabled/default
sudo sed -i "s|#\tfastcgi_pass unix|\tfastcgi_pass unix|g" /etc/nginx/sites-enabled/default
sudo sed -i "s|# deny access to .htaccess files|}\n\n\n\t# deny access to .htaccess files|g" /etc/nginx/sites-enabled/default

sudo nginx -t
sudo systemctl restart nginx


sudo apt install php-common php-iconv php-curl php-mbstring php-xmlrpc php-soap php-zip php-gd php-xml php-intl php-json libpcre3 libpcre3-dev graphviz aspell ghostscript clamav

wget https://raw.githubusercontent.com/melongist/CSL/master/moodle/moodledb.sql
sudo mysql -u root -p < moodledb.sql
sudo rm moodledb.sql

wget -c https://download.moodle.org/download.php/direct/stable310/moodle-latest-310.zip
sudo unzip moodle-latest-310.zip -d /var/www/html/

sudo chown www-data:www-data -R /var/www/html/moodle
sudo chmod 775 -R /var/www/html/moodle

sudo mkdir -p /var/moodledata
sudo chmod 775 -R /var/moodledata
sudo chown www-data:www-data -R  /var/moodledata

sudo cp /var/www/html/moodle/config-dist.php /var/www/html/moodle/config.php

sudo sed -i "s/$CFG->dbtype    = 'pgsql';/$CFG->dbtype    = 'mariadb';/" /var/www/html/moodle/config.php
sudo sed -i "s/$CFG->dbuser    = 'username';/$CFG->dbuser    = 'moodleadmin';/" /var/www/html/moodle/config.php
sudo sed -i "s/$CFG->dbpass    = 'password';/$CFG->dbpass    = 'Secur3P@zzwd';/" /var/www/html/moodle/config.php
sudo sed -i "s/$CFG->wwwroot   = 'http:\/\/example.com\/moodle';/$CFG->wwwroot   = 'http:\/\/learning.codestart.kr\/moodle';/" /var/www/html/moodle/config.php
sudo sed -i "s/$CFG->dataroot  = '\/home\/example\/moodledata';/$CFG->dataroot  = '\/var\/moodledata';/" /var/www/html/moodle/config.php

wget https://raw.githubusercontent.com/melongist/CSL/master/moodle/moodle.conf
sudo cp moodle.conf /etc/nginx/conf.d/moodle.conf
sudo chown root:root /etc/nginx/conf.d/moodle.conf
sudo chmod 644 /etc/nginx/conf.d/moodle.conf
sudo rm moodle.conf

sudo nginx -t
sudo systemctl reload nginx





