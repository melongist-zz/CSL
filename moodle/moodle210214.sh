#!/bin/bash
#Korean HUSTOJ installation script
#Made by melongist(what_is_computer@msn.com)
#for Korean

VER_DATE="2021.02.14"

THISFILE="moodle210214.sh"
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


#nginx + https://docs.moodle.org/310/en/Step-by-step_Installation_Guide_for_Ubuntu
sudo apt install -y nginx
sudo systemctl is-enabled nginx

sudo apt install -y mysql-client mysql-server php

sudo mysql_secure_installation


sudo apt install -y graphviz aspell ghostscript clamav php7.4-pspell php7.4-curl php7.4-gd php7.4-intl php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-ldap php7.4-zip php7.4-soap php7.4-mbstring php7.4-fpm
sudo systemctl is-enabled php7.4-fpm

sudo sed -i "s:index index.html:index index.php index.html:g" /etc/nginx/sites-enabled/default
sudo sed -i "s:#location ~ \\\.php\\$:location ~ \\\.php\\$:g" /etc/nginx/sites-enabled/default
sudo sed -i "s:#\tinclude snippets:\tinclude snippets:g" /etc/nginx/sites-enabled/default
sudo sed -i "s|#\tfastcgi_pass unix|\tfastcgi_pass unix|g" /etc/nginx/sites-enabled/default
sudo sed -i "s|# deny access to .htaccess files|}\n\n\n\t# deny access to .htaccess files|g" /etc/nginx/sites-enabled/default

sudo nginx -t
sudo systemctl restart nginx


wget -c https://download.moodle.org/download.php/direct/stable310/moodle-latest-310.tgz
sudo tar -xvzf moodle-latest-310.tgz
sudo mv -f moodle /var/www/html/
sudo chown -R www-data:www-data /var/www/html/moodle
rm moodle-latest-310.tgz


sudo mkdir -p /var/moodledata
sudo chown -R www-data:www-data /var/moodledata
sudo chmod -R 777 /var/moodledata
sudo chmod -R 0755 /var/www/html/moodle

sudo sed -i "s/# pid-file/default_storage_engine = innodb\n# pid-file/g" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i "s/# pid-file/innodb_file_per_table = 1\n# pid-file/g" /etc/mysql/mysql.conf.d/mysqld.cnf
#sudo sed -i "s/# pid-file/innodb_file_format = Barracuda\n# pid-file/g" /etc/mysql/mysql.conf.d/mysqld.cnf

sudo service mysql restart

wget https://raw.githubusercontent.com/melongist/CSL/master/moodle/moodledb.sql
sudo mysql -u root -p < moodledb.sql
rm moodledb.sql

sudo chmod -R 777 /var/www/html/moodle






