#!/bin/bash
#Korean HUSTOJ installation script
#Made by melongist(what_is_computer@msn.com)
#for Korean

VER_DATE="2021.02.15"

THISFILE="moodle210215.sh"

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash ${THISFILE}'"
  exit 1
fi

cd

#for South Korea's timezone
sudo timedatectl set-timezone 'Asia/Seoul'

sudo apt update
sudo apt -y upgrade


#https://docs.moodle.org/310/en/Step-by-step_Installation_Guide_for_Ubuntu + with Nginx

sudo apt install -y nginx

sudo apt install -y mysql-client mysql-server
sudo mysql_secure_installation

sudo apt install -y php php-fpm php-cli php-mysql php-gd php-imagick php-tidy php-xmlrpc

sudo apt install -y graphviz aspell ghostscript clamav php7.4-pspell php7.4-curl php7.4-intl php7.4-xml php7.4-ldap php7.4-zip php7.4-soap php7.4-mbstring


sudo sed -i "s:memory_limit = 128M:memory_limit = 256M:g" /etc/php/7.4/fpm/php.ini
sudo sed -i "s:upload_max_filesize = 2M:upload_max_filesize = 64M:g" /etc/php/7.4/fpm/php.ini

sudo sed -i "s:index index.html:index index.php index.html:g" /etc/nginx/sites-enabled/default
sudo sed -i "s:#location ~ \\\.php\\$:location ~ \\\.php\\$:g" /etc/nginx/sites-enabled/default
sudo sed -i "s:#\tinclude snippets:\tinclude snippets:g" /etc/nginx/sites-enabled/default
sudo sed -i "s|#\tfastcgi_pass unix|\tfastcgi_pass unix|g" /etc/nginx/sites-enabled/default
sudo sed -i "s|# deny access to .htaccess files|}\n\n\n\t# deny access to .htaccess files|g" /etc/nginx/sites-enabled/default

#for nginx moodle css/js
sudo sed -i "s#server_name _;#server_name _;\n\n\tlocation ~ [^/]\\.php(/|$) {\n\t\tfastcgi_split_path_info  ^(.+\\.php)(/.+)$;\n\t\tfastcgi_index            index.php;\n\t\tfastcgi_pass             unix:/var/run/php/php7.4-fpm.sock;\n\t\tinclude                  fastcgi_params;\n\t\tfastcgi_param   PATH_INFO       \$fastcgi_path_info;\n\t\tfastcgi_param   SCRIPT_FILENAME \$document_root\$fastcgi_script_name;\n\t}#g" /etc/nginx/sites-enabled/default

sudo systemctl restart nginx
sudo systemctl restart php7.4-fpm.service

sudo apt install -y git
cd /opt
sudo git clone git://git.moodle.org/moodle.git
cd moodle
sudo git branch --track MOODLE_311_STABLE origin/MOODLE_311_STABLE
sudo git checkout MOODLE_311_STABLE

cd
sudo cp -R /opt/moodle /var/www/html/
sudo mkdir /var/moodledata
sudo chown -R www-data /var/moodledata
sudo chmod -R 777 /var/moodledata
sudo chmod -R 0755 /var/www/html/moodle


sudo sed -i "s|# pid-file|innodb_file_per_table = 1\n# pid-file|g" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart

wget https://raw.githubusercontent.com/melongist/CSL/master/moodle/moodledb.sql
sudo mysql -u root -p < moodledb.sql
sudo rm moodledb.sql

sudo chmod -R 777 /var/www/html/moodle







