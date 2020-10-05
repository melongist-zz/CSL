#!/bin/bash
#for domjudge7.4.0.dev + Ubuntu 20.04 LTS Server

#judgedaemon 만들기

sudo apt update
sudo apt -y upgrade

sudo apt -y install acl
sudo apt -y install zip

sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo add-apt-repository 'deb [arch=amd64] http://mariadb.mirror.globo.tech/repo/10.5/ubuntu focal main'

sudo apt update
sudo apt -y upgrade

sudo apt -y install mariadb-server mariadb-client

echo ""
echo "------"
echo "Change!! Mariadb's root password to your own!!!"
echo "------"
echo ""
#root 패스워드를 반드시 설정 해야함 #1
sudo mysql_secure_installation

sudo apt -y install apache2
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
sudo apt -y install build-essential
sudo apt -y install libcgroup-dev
sudo apt -y install libcurl4-openssl-dev
sudo apt -y install libjsoncpp-dev

#wget https://www.domjudge.org/releases/domjudge-7.3.0.tar.gz
#tar xvf domjudge-7.3.0.tar.gz
#tar xvf domjudge.tar.gz
#cd domjudge-7.3.0

#잘 안되어서 개발중인 7.4.0.dev 버전을 직접 받아서 깃허브에 저장함. 원래는 정식 안정 버전을 받아서 진행하면 됨.
#정식 안정 버전을 어떻게 하면 되는지 알지만, 신버전에서 성공했기 때문에 스킵함.
wget https://raw.githubusercontent.com/melongist/CSL/master/domjudge/domjudge-snapshot-20201005.tar.gz
tar xvf domjudge-snapshot-20201005.tar.gz
sudo mv domjudge-snapshot-20201005 domjudge-7.4.0.dev
cd domjudge-7.4.0.dev

./configure --with-baseurl=BASEURL
make domserver
sudo make install-domserver

cd /opt/domjudge/domserver/bin
#./dj_setup_database genpass # 안해도 생성됨


echo ""
echo "------"
echo "Input!! Mariadb's root password with your own!!!"
echo "------"
echo ""
# 반드시 #1에서 설정한 root 패스워드를 입력 해야함
sudo ./dj_setup_database -u root -r install


sudo ln -s /opt/domjudge/domserver/etc/apache.conf /etc/apache2/conf-available/domjudge.conf
sudo ln -s /opt/domjudge/domserver/etc/domjudge-fpm.conf /etc/php/7.4/fpm/pool.d/domjudge.conf

sudo a2enmod proxy_fcgi setenvif rewrite
sudo systemctl restart apache2

sudo a2enconf php7.4-fpm domjudge
sudo systemctl reload apache2

sudo service php7.4-fpm reload
sudo service apache2 reload

#자동 페이지 변경 스크립트 파일 생성
cd
sudo rm -f /var/www/html/index.html
echo "<script>document.location=\"./domjudge/\";</script>" > index.html
sudo chmod 644 index.html
sudo chown root:root index.html
sudo mv index.html /var/www/html/

#필요 없는 패키지 삭제
sudo apt -y autoremove

clear

PASSWORD=$(cat /opt/domjudge/domserver/etc/initial_admin_password.secret)

echo "domjudge 7.4.0.DEV judgedaemon installed!!"
echo "Ver 2020.10.04"
echo "Made by melongist(what_is_computer@msn.com)"
echo "admin ID : admin"
echo "admin PW : $PASSWORD"

