#!/bin/bash

sudo apt update
sudo apt -y upgrade

sudo apt -y install acl
sudo apt -y install zip

sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo add-apt-repository 'deb [arch=amd64] http://mariadb.mirror.globo.tech/repo/10.5/ubuntu focal main'

sudo apt update
sudo apt -y upgrade

sudo apt -y install mariadb-server mariadb-client

sudo mysql_secure_installation

sudo apt -y install nginx
sudo apt -y install php
sudo apt -y install php-fpm
sudo apt -y install php-gd
sudo apt -y install php-cli
sudo apt -y install php-intl
sudo apt -y install php-mbstring
sudo apt -y install php-mysql
sudo apt -y install php-curl
sudo apt -y install php-json
sudo apt -y install php-xml
sudo apt -y install php-zip
sudo apt -y install composer
sudo apt -y install ntp

wget https://www.domjudge.org/releases/domjudge-7.3.0.tar.gz
sudo tar xvf domjudge-7.3.0.tar.gz

sudo apt -y install build-essential
sudo apt -y install libcgroup-dev
sudo apt -y install libcurl4-openssl-dev
sudo apt -y install libjsoncpp-dev

cd domjudge-7.3.0
sudo ./configure --with-domjudge-user=$USER --with-baseurl=BASEURL
sudo make domserver
sudo make install-domserver

PASSWORD=$(cat /opt/domjudge/domserver/etc/initial_admin_password.secret)

cd /opt/domjudge/domserver/bin
sudo ./dj_setup_database -u root -p -r install

sudo ln -s /opt/domjudge/domserver/etc/nginx-conf /etc/nginx/sites-enabled/domjudge
sudo ln -s /opt/domjudge/domserver/etc/domjudge-fpm.conf /etc/php/7.4/fpm/pool.d/domjudge.conf

sudo service php7.4-fpm reload
sudo service nginx reload

cd
sudo rm -f /var/www/html/index.html
echo "<script>document.location=\"./domjudge/\";</script>" > index.html
sudo chmod 644 index.html
sudo chown root:root index.html
sudo mv index.html /var/www/html/

sudo apt -y autoremove

clear

echo "domjudge 7.3.0 install completed!!"
echo "Ver 2020.09.15"
echo "Made by melongist(what_is_computer@msn.com)"
echo "admin ID : admin"
echo "admin PW : $PASSWORD"












