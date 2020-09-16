#!/bin/bash
#Ubuntu 20.04 LTS

sudo apt update
sudo apt -y upgrade

#sudo apt -y install acl
#sudo apt -y install zip

sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo add-apt-repository 'deb [arch=amd64] http://mariadb.mirror.globo.tech/repo/10.5/ubuntu focal main'

sudo apt update
sudo apt -y upgrade

sudo apt -y install mariadb-server mariadb-client

clear
echo "Mariadb의 root 패스워드를 반드시 바꿔야 합니다. 나중에 다시 사용합니다."

#root 패스워드 반드시 설정해야함. #1
sudo mysql_secure_installation

sudo apt -y install apache2

sudo apt -y install php
sudo apt -y install php-fpm

sudo a2enmod proxy_fcgi setenvif
sudo systemctl restart apache2

sudo a2enconf php7.4-fpm
sudo systemctl reload apache2

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

sudo apt -y install build-essential
sudo apt -y install libcgroup-dev
sudo apt -y install libcurl4-openssl-dev
sudo apt -y install libjsoncpp-dev


wget https://www.domjudge.org/releases/domjudge-7.3.0.tar.gz
tar xvf domjudge-7.3.0.tar.gz

cd domjudge-7.3.0
./configure --with-domjudge-user=$USER --with-baseurl=BASEURL
make domserver
sudo make install-domserver

PASSWORD=$(sudo cat /opt/domjudge/domserver/etc/initial_admin_password.secret)

cd /opt/domjudge/domserver/bin

sudo ./dj_setup_database genpass
echo "Mariadb의 root 패스워드를 입력하세요."
# #1에서 설정한 root 패스워드 입력
sudo ./dj_setup_database -u root -r install

sudo ln -s /opt/domjudge/domserver/etc/apache.conf /etc/apache2/conf-available/domjudge.conf
sudo ln -s /opt/domjudge/domserver/etc/domjudge-fpm.conf /etc/php/7.4/fpm/pool.d/domjudge.conf

sudo a2enmod proxy_fcgi setenvif rewrite
sudo systemctl restart apache2
sudo a2enconf php7.4-fpm domjudge
sudo systemctl reload apache2

sudo service php7.4-fpm reload
sudo service apache2 reload

cd
sudo rm -f /var/www/html/index.html
echo "<script>document.location=\"./domjudge/\";</script>" > index.html
sudo chmod 644 index.html
sudo chown root:root index.html
sudo mv index.html /var/www/html/

sudo apt -y autoremove

clear

echo "apache2 based"
echo "domjudge 7.3.0 install completed!!"
echo "Ver 2020.09.17"
echo "Made by melongist(what_is_computer@msn.com)"
echo "admin ID : admin"
echo "admin PW : $PASSWORD"












