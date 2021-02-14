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

sudo apt install -y nginx
sudo systemctl is-enabled nginx

sudo apt install -y mysql-client mysql-server php php-mysql

sudo mysql_secure_installation

sudo sed -i "s/# pid-file/innodb_file_per_table = 1\n# pid-file/g" /etc/mysql/mysql.conf.d/mysqld.cnf
wget https://raw.githubusercontent.com/melongist/CSL/master/moodle/moodledb.sql
sudo mysql -u root -p < moodledb.sql
rm moodledb.sql
sudo service mysql restart

sudo apt install -y sudo apt install php-fpm php-common php-iconv php-curl php-mbstring php-xmlrpc php-soap php-zip php-gd php-xml php-intl php-json libpcre3 libpcre3-dev graphviz aspell ghostscript clamav
sudo systemctl is-enabled php7.4-fpm

sudo sed -i "s:index index.html:index index.php index.html:g" /etc/nginx/sites-enabled/default
sudo sed -i "s:#location ~ \\\.php\\$:location ~ \\\.php\\$:g" /etc/nginx/sites-enabled/default
sudo sed -i "s:#\tinclude snippets:\tinclude snippets:g" /etc/nginx/sites-enabled/default
sudo sed -i "s|#\tfastcgi_pass unix|\tfastcgi_pass unix|g" /etc/nginx/sites-enabled/default
sudo sed -i "s|# deny access to .htaccess files|}\n\n\n\t# deny access to .htaccess files|g" /etc/nginx/sites-enabled/default
sudo sed -i "s:php7.0:php7.4:g" /etc/nginx/sites-enabled/default

sudo nginx -t
sudo systemctl restart nginx


wget -c https://download.moodle.org/download.php/direct/stable310/moodle-latest-310.tgz
tar -xvzf moodle-latest-310.tgz
sudo mv -f moodle /var/www/html/
#sudo chown -R www-data:www-data /var/www/html/moodle
rm moodle-latest-310.tgz
#sudo chmod -R 0755 /var/www/html/moodle/



sudo mkdir -p /var/moodledata
sudo chown -R www-data /var/moodledata
sudo chmod -R 0777 /var/moodledata


