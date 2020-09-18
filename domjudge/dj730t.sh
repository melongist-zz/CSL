#!/bin/bash
#for Ubuntu 20.04 LTS AWS Server and Desktop

apt update
apt -y upgrade

#sudo apt -y install acl
#sudo apt -y install zip

apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
add-apt-repository 'deb [arch=amd64] http://mariadb.mirror.globo.tech/repo/10.5/ubuntu focal main'

apt update
apt -y upgrade

apt -y install mariadb-server mariadb-client

echo ""
echo "----------------------------------"
echo "Change!! Mariadb's' root password!"
echo "----------------------------------"
echo ""


#root 패스워드 반드시 설정해야함. #1
mysql_secure_installation

apt -y install apache2

apt -y install php
apt -y install php-fpm

a2enmod proxy_fcgi setenvif
systemctl restart apache2

a2enconf php7.4-fpm
systemctl reload apache2

apt -y install php-gd
apt -y install php-cli
apt -y install php-intl
apt -y install php-mbstring
apt -y install php-mysql
apt -y install php-curl
apt -y install php-json
apt -y install php-xml
apt -y install php-zip
apt -y install composer
apt -y install ntp

apt -y install build-essential
apt -y install libcgroup-dev
apt -y install libcurl4-openssl-dev
apt -y install libjsoncpp-dev


wget https://www.domjudge.org/releases/domjudge-7.3.0.tar.gz
tar xvf domjudge-7.3.0.tar.gz

cd domjudge-7.3.0
./configure --with-domjudge-user=$USER --with-baseurl=BASEURL
make domserver
make install-domserver

cd /opt/domjudge/domserver/bin
./dj_setup_database genpass

echo ""
echo "----------------------------------"
echo "Submit!! Mariadb's' root password!"
echo "----------------------------------"
echo ""
# #1에서 설정한 root 패스워드 입력
./dj_setup_database -u root -r install

ln -s /opt/domjudge/domserver/etc/apache.conf /etc/apache2/conf-available/domjudge.conf
ln -s /opt/domjudge/domserver/etc/domjudge-fpm.conf /etc/php/7.4/fpm/pool.d/domjudge.conf

a2enmod proxy_fcgi setenvif rewrite
systemctl restart apache2
a2enconf php7.4-fpm domjudge
systemctl reload apache2

service php7.4-fpm reload
service apache2 reload

cd
rm -f /var/www/html/index.html
echo "<script>document.location=\"./domjudge/\";</script>" > index.html
chmod 644 index.html
chown www-data:www-data index.html
mv index.html /var/www/html/

apt -y autoremove

PASSWORD=$(cat /opt/domjudge/domserver/etc/initial_admin_password.secret)

clear

echo "apache2 based"
echo "domjudge 7.3.0 install completed!!"
echo "Ver 2020.09.19"
echo "Made by melongist(what_is_computer@msn.com)"
echo "admin ID : admin"
echo "admin PW : $PASSWORD"
