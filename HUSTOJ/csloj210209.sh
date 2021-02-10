#!/bin/bash
#CSL HUSTOJ
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teacher

VER_DATE="2021.02.09"

THISFILE="csloj210209.sh"
SRCZIP="hustoj210209.zip"

#RESTOREFILE="restore.sh"

SQLFILE="csl100v05jol.sql"
IMGFILE="csl100v01image.tar.gz"
DATAFILE="csl100v06data.zip"


clear

#for South Korea's timezone
timedatectl set-timezone 'Asia/Seoul'

apt update
apt -y install subversion
apt -y install zip
apt -y install unzip


#clear for reinstallation
apt -y remove phpmyadmin
apt -y purge phpmyadmin
apt -y purge php7.* php-*
apt -y remove nginx
apt -y purge nginx
apt -y purge mysql-*
rm -rf /var/lib/mysql/
rm -rf /etc/mysql/
rm -rf /var/log/mysql
rm -rf /etc/php
deluser --remove-home mysql
deluser --remove-home judge
apt -y autoremove


clear

echo ""
echo "---- CSL(Computer Science teachers's computer science Love) ----"
echo ""

if [[ -z $SUDO_USER ]] ; then
  echo "Use 'sudo bash ${THISFILE}'"
  exit 1
fi


cd


/usr/sbin/useradd -m -u 1536 judge
cd /home/judge/ || exit

#using tgz src files
#wget -O hustoj.tar.gz http://dl.hustoj.com/hustoj.tar.gz
#tar xzf hustoj.tar.gz
#svn up src
#svn co https://github.com/zhblue/hustoj/trunk/trunk/  src

#how to make src zip
#zip -r hustoj210107.zip ./src
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/${SRCZIP}
unzip ${SRCZIP}
rm ${SRCZIP}

#------ original intallation scripts 2021.02.09 start




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

chown -R root:root src/web/.svn
chmod 750 -R src/web/.svn

chown www-data:judge src/web/upload
chown www-data:judge data
chmod 711 -R data
if grep "client_max_body_size" /etc/nginx/nginx.conf ; then 
  echo "client_max_body_size already added" ;
else
  sed -i "s:include /etc/nginx/mime.types;:client_max_body_size    80m;\n\tinclude /etc/nginx/mime.types;:g" /etc/nginx/nginx.conf
fi

mysql -h localhost -u"$USER" -p"$PASSWORD" < src/install/db.sql
echo "insert into jol.privilege values('admin','administrator','true','N');"|mysql -h localhost -u"$USER" -p"$PASSWORD" 

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

cls
reset




#------ original intallation scripts 2021.02.09 end





cd

#db_info.inc.php edit
#for OJ NAME
clear
OJNAME="o"
INPUTS="x"
while [ ${OJNAME} != ${INPUTS} ]; do
  echo -n "Enter  OJ NAME : "
  read OJNAME
  echo -n "Repeat OJ NAME : "
  read INPUTS
done
sed -i "s/OJ_NAME=\"HUSTOJ\"/OJ_NAME=\"${OJNAME}\"/" /home/judge/src/web/include/db_info.inc.php
#for south korea timezone
sed -i "s#//date_default_timezone_set(\"PRC\")#date_default_timezone_set(\"Asia\/Seoul\")#" /home/judge/src/web/include/db_info.inc.php
sed -i "s#//pdo_query(\"SET time_zone ='+8:00'\")#pdo_query(\"SET time_zone ='+9:00'\")#" /home/judge/src/web/include/db_info.inc.php

#for korean kindeditor
sed -i "s/OJ_LANG=\"en\"/OJ_LANG=\"ko\"/" /home/judge/src/web/include/db_info.inc.php
sed -i "s/zh_CN.js/ko.js/" /home/judge/src/web/admin/kindeditor.php

#judge.conf edit
#time result fix ... for use_max_time : to record the max time of all results, not sum of...
sed -i "s/OJ_USE_MAX_TIME=0/OJ_USE_MAX_TIME=1/" /home/judge/etc/judge.conf

#Removing QR codes + CSL link
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/js2.php
mv -f ./js2.php /home/judge/src/web/template/bs3/js.php
chown www-data:${SUDO_USER} /home/judge/src/web/template/bs3/js.php
chmod 664 /home/judge/src/web/template/bs3/js.php

#Replacing msg.txt
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/msg2.txt
mv -f ./msg2.txt /home/judge/src/web/admin/msg.txt
chown www-data:${SUDO_USER} /home/judge/src/web/admin/msg.txt
chmod 664 /home/judge/src/web/admin/msg.txt

#phpmyadmin install script
#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/phadmin00.sh
#mv -f ./phadmin00.sh /home/${SUDO_USER}/
#chown ${SUDO_USER}:${SUDO_USER} /home/${SUDO_USER}/phadmin00.sh
#chmod 664 /home/${SUDO_USER}/phadmin00.sh

#HUSTOJ backup script
#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/backup00.sh
#mv -f ./backup00.sh /home/${SUDO_USER}/
#chown ${SUDO_USER}:${SUDO_USER} /home/${SUDO_USER}/backup00.sh
#chmod 664 /home/${SUDO_USER}/backup00.sh

#jol database overwriting
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/${SQLFILE}
DBUSER=$(grep user /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
PASSWORD=$(grep password /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
#current mysql backup
#c.f. : how to backup from HUSTOJ for CSL :> mysqldump -u debian-sys-maint -p jol > jol.sql
#mysqldump -u ${DBUSER} -p$PASSWORD jol > ./${BACKUPS}/jol.sql
#overwrting
mysql -u ${DBUSER} -p${PASSWORD} jol < ${SQLFILE}
rm ${SQLFILE}
#for restoring
#echo "DBUSER=\$(sudo grep user /etc/mysql/debian.cnf|head -1|awk  '{print \$3}')" >> ./${BACKUPS}/${RESTOREFILE}
#echo "PASSWORD=\$(sudo grep password /etc/mysql/debian.cnf|head -1|awk  '{print \$3}')" >> ./${BACKUPS}/${RESTOREFILE}
#echo "mysql -u \${DBUSER} -p\${PASSWORD} jol < jol.sql" >> ./${BACKUPS}/${RESTOREFILE}

#Coping all problem images to server
#current images backup
#cf. : how to backup images from HUSTOJ for CSL
#directory : /home/judge/src/wb/upload/
#command   : sudo tar zcvf csl100v01image.tar.gz *
#tar zcvf ./${BACKUPS}/upload/images.tar.gz /home/judge/src/web/upload/*
rm -rf /home/judge/src/web/upload/*
#overwriting
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/upload/${IMGFILE}
tar zxvf ${IMGFILE} -C /home/judge/src/web/upload/
rm ${IMGFILE}
chown www-data:www-data -R /home/judge/src/web/upload/*
chmod 644 /home/judge/src/web/upload/*
chmod 755 /home/judge/src/web/upload/image
chown www-data:root -R /home/judge/src/web/upload/index.html
chmod 664 /home/judge/src/web/upload/index.html
#for restoring
#echo "sudo rm -rf /home/judge/src/web/upload/*" >> ./${BACKUPS}/${RESTOREFILE}
#echo "sudo tar zxvf ./upload/images.tar.gz -C /home/judge/src/web/upload/" >> ./${BACKUPS}/${RESTOREFILE}

#Coping all problem *.in & *.out data to server
#current data backup
#c.f. : how to backup test files from HUSTOJ for CSL
#directory : /home/judge/
#command   : sudo zip -r data.zip ./data
#zip -r ./${BACKUPS}/data.zip /home/judge/data
rm -rf /home/judge/data
#overwriting
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/${DATAFILE}
unzip ${DATAFILE} -d /home/judge/
rm ${DATAFILE}
chmod 644 -R /home/judge/data
chown www-data:www-data -R /home/judge/data
chmod 755 /home/judge/data/*
chmod 711 /home/judge/data
chown www-data:judge /home/judge/data
#for restoring
#echo "sudo rm -rf /home/judge/data" >> ./${BACKUPS}/${RESTOREFILE}
#echo "sudo unzip ./data.zip -d /home/judge/" >> ./${BACKUPS}/${RESTOREFILE}

#file upload privelege fix 711 to 644
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/phpfm.php
mv -f ./phpfm.php /home/judge/src/web/admin/
chown www-data:root /home/judge/src/web/admin/phpfm.php
chmod 664 /home/judge/src/web/admin/phpfm.php


#problem_add_page.php customizing for front, rear, bann, credits fields
#mv -f /home/judge/src/web/admin/problem_add_page.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_add_page.php
mv -f ./problem_add_page.php /home/judge/src/web/admin/
chown www-data:root /home/judge/src/web/admin/problem_add_page.php
chmod 664 /home/judge/src/web/admin/problem_add_page.php
#for restoring
#echo "sudo cp -f ./admin/problem_add_page.php /home/judge/src/web/admin/" >> ./${BACKUPS}/${RESTOREFILE}

#problem_add.php customizing for front, rear, bann, credits fields
#mv -f /home/judge/src/web/admin/problem_add.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_add.php
mv -f ./problem_add.php /home/judge/src/web/admin/
chown www-data:root /home/judge/src/web/admin/problem_add.php
chmod 664 /home/judge/src/web/admin/problem_add.php
#for restoring
#echo "sudo cp -f ./admin/problem_add.php /home/judge/src/web/admin/" >> ./${BACKUPS}/${RESTOREFILE}

#problem_edit.php customizing for front, rear, bann, credits fields
#mv -f /home/judge/src/web/admin/problem_edit.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_edit.php
mv -f ./problem_edit.php /home/judge/src/web/admin/
chown www-data:root /home/judge/src/web/admin/problem_edit.php
chmod 664 /home/judge/src/web/admin/problem_edit.php
#for restoring
#echo "sudo cp -f ./admin/problem_edit.php /home/judge/src/web/admin/" >> ./${BACKUPS}/${RESTOREFILE}

#problem_export_xml.php customizing for front, rear, bann, credits fields
#sudo mv -f /home/judge/src/web/admin/problem_export_xml.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_export_xml.php
mv -f ./problem_export_xml.php /home/judge/src/web/admin/
chown www-data:root /home/judge/src/web/admin/problem_export_xml.php
chmod 664 /home/judge/src/web/admin/problem_export_xml.php
#for restoring
#echo "sudo cp -f ./admin/problem_export_xml.php /home/judge/src/web/admin/" >> ./${BACKUPS}/${RESTOREFILE}

#problem_export.php customizing for front, rear, bann, credits fields
#sudo mv -f /home/judge/src/web/admin/problem_export.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_export.php
mv -f ./problem_export.php /home/judge/src/web/admin/
chown www-data:root /home/judge/src/web/admin/problem_export.php
chmod 664 /home/judge/src/web/admin/problem_export.php
#for restoring
#echo "sudo cp -f ./admin/problem_export.php /home/judge/src/web/admin/" >> ./${BACKUPS}/${RESTOREFILE}

#problem_import_xml.php customizing for front, rear, bann, credits fields
#sudo mv -f /home/judge/src/web/admin/problem_import_xml.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_import_xml.php
mv -f ./problem_import_xml.php /home/judge/src/web/admin/
chown www-data:root /home/judge/src/web/admin/problem_import_xml.php
chmod 664 /home/judge/src/web/admin/problem_import_xml.php
#for restoring
#echo "sudo cp -f ./admin/problem_import_xml.php /home/judge/src/web/admin/" >> ./${BACKUPS}/${RESTOREFILE}

#problem_import.php customizing for front, rear, bann, credits fields
#sudo mv -f /home/judge/src/web/admin/problem_import.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_import.php
mv -f ./problem_import.php /home/judge/src/web/admin/
chown www-data:root /home/judge/src/web/admin/problem_import.php
chmod 664 /home/judge/src/web/admin/problem_import.php
#for restoring
#echo "sudo cp -f ./admin/problem_import.php /home/judge/src/web/admin/" >> ./${BACKUPS}/${RESTOREFILE}

#problem.php customizing for front, rear, bann, credits fields
#sudo mv -f /home/judge/src/web/include/problem.php ./${BACKUPS}/include/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/include/problem.php
mv -f ./problem.php /home/judge/src/web/include/
chown www-data:root /home/judge/src/web/include/problem.php
chmod 664 /home/judge/src/web/include/problem.php
#for restoring
#echo "sudo cp -f ./include/problem.php /home/judge/src/web/include/" >> ./${BACKUPS}/${RESTOREFILE}

#problem.php customizing for front, rear, bann, credits fields
#sudo mv -f /home/judge/src/web/template/bs3/problem.php ./${BACKUPS}/bs3/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/problem.php
mv -f ./problem.php /home/judge/src/web/template/bs3/
chown www-data:root /home/judge/src/web/template/bs3/problem.php
chmod 644 /home/judge/src/web/template/bs3/problem.php
#for restoring
#echo "sudo cp -f ./bs3/problem.php /home/judge/src/web/template/bs3/" >> ./${BACKUPS}/${RESTOREFILE}

#problem.php customizing for front, rear, bann, credits fields
#sudo mv -f /home/judge/src/web/template/bs3/submitpage.php ./${BACKUPS}/bs3/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/submitpage.php
mv -f ./submitpage.php /home/judge/src/web/template/bs3/
chown www-data:root /home/judge/src/web/template/bs3/submitpage.php
chmod 644 /home/judge/src/web/template/bs3/submitpage.php
#for restoring
#echo "sudo cp -f ./bs3/submitpage.php /home/judge/src/web/template/bs3/" >> ./${BACKUPS}/${RESTOREFILE}

#submit.php customizing for front, rear, bann, credits fields
#sudo mv -f /home/judge/src/web/submit.php ./${BACKUPS}/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/submit.php
mv -f ./submit.php /home/judge/src/web/
chown www-data:root /home/judge/src/web/submit.php
chmod 644 /home/judge/src/web/submit.php
#for restoring
#echo "sudo cp -f ./submit.php /home/judge/src/web/" >> ./${BACKUPS}/${RESTOREFILE}

clear


#HUSTOJ db_info.inc.php settings
#sudo cp /home/judge/src/web/include/db_info.inc.php ./${BACKUPS}/include/
#for restoring
#echo "sudo cp -f ./include/db_info.inc.php /home/judge/src/web/include/" >> ./${BACKUPS}/${RESTOREFILE}


echo ""
echo "--- db_info.inc.php options ---"
echo ""
#for able/unable to register
INPUTS="n"
while [ ${INPUTS} = "n" ]; do
  echo -n "OJ_REGISTER=false    OK?[y/n] "
  read INPUTS
  if [ ${INPUTS} = "y" ]; then
    sed -i "s/OJ_REGISTER=true/OJ_REGISTER=false/" /home/judge/src/web/include/db_info.inc.php
  else  
    echo -n "OJ_REGISTER=true   OK?[y/n] "
    read INPUTS
  fi
done
#for able/unable VCODE
INPUTS="n"
while [ ${INPUTS} = "n" ]; do
  echo -n "OJ_VCODE=true    OK?[y/n] "
  read INPUTS
  if [ ${INPUTS} = "y" ]; then
    sed -i "s/OJ_VCODE=false/OJ_VCODE=true/" /home/judge/src/web/include/db_info.inc.php
  else  
    echo -n "OJ_VCODE=false   OK?[y/n] "
    read INPUTS
  fi
done
#for OJ_SHOW_DIFF
INPUTS="n"
while [ ${INPUTS} = "n" ]; do
  echo -n "OJ_SHOW_DIFF=true    OK?[y/n] "
  read INPUTS
  if [ ${INPUTS} = "y" ]; then
    sed -i "s/OJ_SHOW_DIFF=false/OJ_SHOW_DIFF=true/" /home/judge/src/web/include/db_info.inc.php
  else  
    echo -n "OJ_SHOW_DIFF=false   OK?[y/n] "
    read INPUTS
  fi
done


#result time fix ... use_max_time
#sudo cp /home/judge/etc/judge.conf ./${BACKUPS}/
sed -i "s/OJ_USE_MAX_TIME=0/OJ_USE_MAX_TIME=1/" /home/judge/etc/judge.conf
#for restoring
#echo "sudo cp -f ./judge.conf /home/judge/etc/" >> ./${BACKUPS}/${RESTOREFILE}


#curl installation
sudo apt -y install curl

#Identifing AWS Ubuntu 20.04 LTS
if [ -f /etc/default/grub.d/50-cloudimg-settings.cfg ]; then
  SERVERTYPES="AWS SERVER"
  IPADDRESS=($(curl http://checkip.amazonaws.com))
else
  SERVERTYPES="LOCAL SERVER"
  IPADDRESS=($(hostname -I))
fi

clear

#Removing QR codes + CSL link
#sudo mv -f /home/judge/src/web/template/bs3/js.php ./${BACKUPS}/bs3/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/js2.php
mv -f ./js2.php /home/judge/src/web/template/bs3/js.php
chown www-data:${SUDO_USER} /home/judge/src/web/template/bs3/js.php
chmod 664 /home/judge/src/web/template/bs3/js.php
#for restoring
#echo "sudo cp -f ./bs3/js.php /home/judge/src/web/template/bs3/" >> ./${BACKUPS}/${RESTOREFILE}

#Replacing msg.txt
#sudo mv -f /home/judge/src/web/admin/msg.txt ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/msg2.txt
mv -f ./msg2.txt /home/judge/src/web/admin/msg.txt
chown www-data:root /home/judge/src/web/admin/msg.txt
chmod 644 /home/judge/src/web/admin/msg.txt
#for restoring
#echo "sudo cp -f ./admin/msg.txt /home/judge/src/web/admin/" >> ./${BACKUPS}/${RESTOREFILE}
#echo "clear" >> ./${BACKUPS}/${RESTOREFILE}
#echo "echo \"\"" >> ./${BACKUPS}/${RESTOREFILE}
#echo "echo \"HUSTOJ ${BACKUPS} successfully restored!\"" >> ./${BACKUPS}/${RESTOREFILE} 
#echo "echo \"\"" >> ./${BACKUPS}/${RESTOREFILE}

clear

echo ""
echo "--- $OJNAME CSL HUSTOJ installed ---"
echo ""
echo "Change admin password!"
echo ""
echo "$SERVERTYPES"
echo "http://${IPADDRESS[0]}"
echo ""
echo ""
echo "Check & Edit HUSTOJ configurations"
echo "sudo vi /home/judge/src/web/include/db_info.inc.php"
echo ""
echo "This Script is supported by CSL(South Korea CSTA)"
echo ""

