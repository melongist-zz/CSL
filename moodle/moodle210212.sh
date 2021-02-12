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



#https://docs.moodle.org/310/en/Step-by-step_Installation_Guide_for_Ubuntu
for pkg in apache2 mysql-client mysql-server php libapache2-mod-php graphviz aspell ghostscript clamav php7.4-pspell php7.4-curl php7.4-gd php7.4-intl php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-ldap php7.4-zip php7.4-soap php7.4-mbstring git
do
  while ! sudo apt install -y "$pkg" 
  do
    echo "Network fail, retry... you might want to change another apt source for install"
  done
done

sudo service apache2 restart

cd /opt

sudo git clone git://git.moodle.org/moodle.git

cd moodle

sudo git branch -a

sudo git branch --track MOODLE_39_STABLE origin/MOODLE_39_STABLE

sudo git checkout MOODLE_39_STABLE

sudo cp -R /opt/moodle /var/www/html/

sudo mkdir /var/moodledata

sudo chown -R www-data /var/moodledata

sudo chmod -R 777 /var/moodledata

sudo chmod -R 0755 /var/www/html/moodle


sudo sed -i -e '$a\\' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i -e '$a#by ${THISFILE} installation' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i -e '$adefault_storage_engine = innodb' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i -e '$ainnodb_file_per_table = 1' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i -e '$ainnodb_file_format = Barracuda' /etc/mysql/mysql.conf.d/mysqld.cnf


sudo service mysql restart

DBUSER=$(grep user /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
PASSWORD=$(grep password /etc/mysql/debian.cnf|head -1|awk  '{print $3}')


wget https://raw.githubusercontent.com/melongist/CSL/master/moodle/moodledb.sql
sudo mysql -h localhost -u"$DBUSER" -p"$PASSWORD" < moodledb.sql
sudo rm moodledb.sql


sudo chmod -R 777 /var/www/html/moodle

sudo chmod -R 0755 /var/www/html/moodle



