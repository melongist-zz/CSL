#!/bin/bash

if [[ -z $SUDO_USER ]] ; then
  echo "Use 'sudo bash csl100v10.sh'"
  exit 1
fi

cd

#for South Korea's timezone
timedatectl set-timezone 'Asia/Seoul'


apt-get update
apt-get install -y subversion

/usr/sbin/useradd -m -u 1536 judge
cd /home/judge/ || exit

wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/hustoj201130.tar.gz

tar zxvf hustoj201130.tar.gz

for pkg in net-tools make flex g++ clang libmysqlclient-dev libmysql++-dev php-fpm nginx mysql-server php-mysql  php-common php-gd php-zip fp-compiler openjdk-11-jdk mono-devel php-mbstring php-xml php-curl php-intl php-xmlrpc php-soap
do
	while ! apt-get install -y "$pkg" 
	do
		echo "Network fail, retry... you might want to change another apt source for install"
	done
done

USER=$(grep user /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
PASSWORD=$(grep password /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
CPU=$(grep "cpu cores" /proc/cpuinfo |head -1|awk '{print $4}')

mkdir etc data log backup

cp src/install/java0.policy  /home/judge/etc
cp src/install/judge.conf  /home/judge/etc
chmod +x src/install/ans2out

if grep "OJ_SHM_RUN=0" etc/judge.conf ; then
	mkdir run0 run1 run2 run3
	chown judge run0 run1 run2 run3
fi

sed -i "s/OJ_USER_NAME=root/OJ_USER_NAME=$USER/g" etc/judge.conf
sed -i "s/OJ_PASSWORD=root/OJ_PASSWORD=$PASSWORD/g" etc/judge.conf
sed -i "s/OJ_COMPILE_CHROOT=1/OJ_COMPILE_CHROOT=0/g" etc/judge.conf
sed -i "s/OJ_RUNNING=1/OJ_RUNNING=$CPU/g" etc/judge.conf

chmod 700 backup
chmod 700 etc/judge.conf

sed -i "s/DB_USER[[:space:]]*=[[:space:]]*\"root\"/DB_USER=\"$USER\"/g" src/web/include/db_info.inc.php
sed -i "s/DB_PASS[[:space:]]*=[[:space:]]*\"root\"/DB_PASS=\"$PASSWORD\"/g" src/web/include/db_info.inc.php
chmod 700 src/web/include/db_info.inc.php
chown -R www-data src/web/

#chown -R root:root src/web/.svn
#chmod 750 -R src/web/.svn

chown www-data:judge src/web/upload
chown www-data:judge data
chmod 711 -R data
if grep "client_max_body_size" /etc/nginx/nginx.conf ; then 
	echo "client_max_body_size already added" ;
else
	sed -i "s:include /etc/nginx/mime.types;:client_max_body_size    80m;\n\tinclude /etc/nginx/mime.types;:g" /etc/nginx/nginx.conf
fi

mysql -h localhost -u"$USER" -p"$PASSWORD" < src/install/db.sql
echo "insert into jol.privilege values('admin','administrator','N');"|mysql -h localhost -u"$USER" -p"$PASSWORD" 

if grep "added by hustoj" /etc/nginx/sites-enabled/default ; then
	echo "default site modified!"
else
	echo "modify the default site"
	sed -i "s#root /var/www/html;#root /home/judge/src/web;#g" /etc/nginx/sites-enabled/default
	sed -i "s:index index.html:index index.php:g" /etc/nginx/sites-enabled/default
	sed -i "s:#location ~ \\\.php\\$:location ~ \\\.php\\$:g" /etc/nginx/sites-enabled/default
	sed -i "s:#\tinclude snippets:\tinclude snippets:g" /etc/nginx/sites-enabled/default
	sed -i "s|#\tfastcgi_pass unix|\tfastcgi_pass unix|g" /etc/nginx/sites-enabled/default
	sed -i "s:}#added by hustoj::g" /etc/nginx/sites-enabled/default
	sed -i "s:php7.0:php7.4:g" /etc/nginx/sites-enabled/default
	sed -i "s|# deny access to .htaccess files|}#added by hustoj\n\n\n\t# deny access to .htaccess files|g" /etc/nginx/sites-enabled/default
fi
/etc/init.d/nginx restart
sed -i "s/post_max_size = 8M/post_max_size = 80M/g" /etc/php/7.4/fpm/php.ini
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 80M/g" /etc/php/7.4/fpm/php.ini
WWW_CONF=$(find /etc/php -name www.conf)
sed -i 's/;request_terminate_timeout = 0/request_terminate_timeout = 128/g' "$WWW_CONF"
sed -i 's/pm.max_children = 5/pm.max_children = 200/g' "$WWW_CONF"
 
COMPENSATION=$(grep 'mips' /proc/cpuinfo|head -1|awk -F: '{printf("%.2f",$2/5000)}')
sed -i "s/OJ_CPU_COMPENSATION=1.0/OJ_CPU_COMPENSATION=$COMPENSATION/g" etc/judge.conf

PHP_FPM=$(find /etc/init.d/ -name "php*-fpm")
$PHP_FPM restart
PHP_FPM=$(service --status-all|grep php|awk '{print $4}')
if [ "$PHP_FPM" != ""  ]; then service "$PHP_FPM" restart ;else echo "NO PHP FPM";fi;

cd src/core || exit 
chmod +x ./make.sh
./make.sh
if grep "/usr/bin/judged" /etc/rc.local ; then
	echo "auto start judged added!"
else
	sed -i "s/exit 0//g" /etc/rc.local
	echo "/usr/bin/judged" >> /etc/rc.local
	echo "exit 0" >> /etc/rc.local
fi
if grep "bak.sh" /var/spool/cron/crontabs/root ; then
	echo "auto backup added!"
else
	crontab -l > conf && echo "1 0 * * * /home/judge/src/install/bak.sh" >> conf && crontab conf && rm -f conf
fi
ln -s /usr/bin/mcs /usr/bin/gmcs

/usr/bin/judged
cp /home/judge/src/install/hustoj /etc/init.d/hustoj
update-rc.d hustoj defaults
systemctl enable hustoj
systemctl enable nginx
systemctl enable mysql
systemctl enable php7.4-fpm
#systemctl enable judged

mkdir /var/log/hustoj/
chown www-data -R /var/log/hustoj/

cd

clear

#db_info.inc.php edit
cd /home/judge/src/web/include

#for OJ NAME
OJNAME="o"
INPUTS="x"
while [ ${OJNAME} != ${INPUTS} ]; do
  echo -n "Enter  OJ NAME : "
  read OJNAME
  echo -n "Repeat OJ NAME : "
  read INPUTS
done
sed -i "s/OJ_NAME=\"HUSTOJ\"/OJ_NAME=\"${OJNAME}\"/" /home/judge/src/web/include/db_info.inc.php

#for korean
sed -i "s/OJ_LANG=\"en\"/OJ_LANG=\"ko\"/" /home/judge/src/web/include/db_info.inc.php
sed -i "s/zh_CN.js/ko.js/" /home/judge/src/web/admin/kindeditor.php

#for south korea timezone
sed -i "s#//date_default_timezone_set(\"PRC\")#date_default_timezone_set(\"Asia\/Seoul\")#" /home/judge/src/web/include/db_info.inc.php
sed -i "s#//pdo_query(\"SET time_zone ='+8:00'\")#pdo_query(\"SET time_zone ='+9:00'\")#" /home/judge/src/web/include/db_info.inc.php

cd
sudo apt -y autoremove


#QR codes removing + CSL link
cd /home/judge/src/web/template/bs3/
sudo rm js.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/js.php
sudo chown www-data js.php
cd

#replace msg.txt
cd /home/judge/src/web/admin/
sudo rm msg.txt
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/msg1.txt
sudo mv msg1.txt msg.txt
sudo chown www-data msg.txt
cd

clear

echo ""
echo "--- $OJNAME install completed ---"
echo ""
echo "check : http://localhost"
echo ""
echo "First of all! : Register admin!"
echo ""
echo "check for configurations"
echo "/home/judge/src/web/include/db_info.inc.php"
echo ""
echo "Made by melongist(what_is_computer@msn.com)"
echo "Powered by CSL"
