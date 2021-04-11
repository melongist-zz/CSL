#!/bin/bash
#CSL HUSTOJ
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teachers

clear

VER_DATE="21.04.05"

THISFILE="csloj210405.sh"
SRCZIP="hustoj210405.zip"

SQLFILE="csl100v06jol.sql"
IMGFILE="csl100v01image.tar.gz"
DATAFILE="csl100v07data.zip"

MAINTENANCEFILE="cslojmaintenance00.sh"
BACKUPFILE="cslojbackup00.sh"




if [[ -z $SUDO_USER ]]
then
  echo "Use 'sudo bash ${THISFILE}'"
  exit 1
fi

echo ""
echo "---- CSL HUSTOJ release ${VER_DATE} ----"
echo ""


if [ -d /home/judge ]
then
  echo -n "Do you want to overwrite the CSL HUSTOJ?[y/n] : "
else
  echo -n "Do you want to install the CSL HUSTOJ?[y/n] : "
fi

INPUTS="n"
read INPUTS
if [ ${INPUTS} = "y" ]
then
  echo ""
  echo ""
  echo "---- CSL HUSTOJ release ${VER_DATE} installation started..."
  echo ""
else
  echo ""
  exit 1
fi

#for OJ NAME
OJNAME="o"
INPUTS="x"
while [ ${OJNAME} != ${INPUTS} ]; do
  echo -n "Enter  the CSL HUSTOJ name you want : "
  read OJNAME
  echo -n "Repeat the CSL HUSTOJ name you want : "
  read INPUTS
done

echo ""
echo ""


if [ -d /home/judge ]
then
  INPUTS="n"
  UPGRADETYPE="0"
  while [ ${INPUTS} != "y" ]; do
    echo "---- Select overwriting type"
    echo " 1: Upgrade PHPs only! Migration"
    echo " 2: New installation!  Reset"
    echo -n "Select [1/2] : "
    read UPGRADETYPE
    echo ""
    if [ ${UPGRADETYPE} = "1" ]
    then
      echo "You selected 1: Upgrade PHPs only!"
      echo -n "Are you sure? [y/n] : "
      read INPUTS
      echo ""
    else
      echo "You selected 2: New installation!"
      echo -n "Are you sure? [y/n] : "
      read INPUTS
      echo ""
    fi
  done

  #backup old hustoj
  wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/${BACKUPFILE} -O /home/${SUDO_USER}/${BACKUPFILE}
  chown ${SUDO_USER}:${SUDO_USER} /home/${SUDO_USER}/${BACKUPFILE}
  sed -i "s/\${SUDO_USER}/${SUDO_USER}/g" /home/${SUDO_USER}/${BACKUPFILE}
  echo "HUSTOJ backup before CSL HUSTOJ release ${VER_DATE} installation"
  bash /home/${SUDO_USER}/${BACKUPFILE} -old


  DBUSER=$(grep user /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
  PASSWORD=$(grep password /etc/mysql/debian.cnf|head -1|awk  '{print $3}')

  if [ ${UPGRADETYPE} = "1" ]
  then
    #backup current old DB
    #how to backup database : mysqldump -u debian-sys-maint -p jol > jol.sql
    mysqldump -u ${DBUSER} -p${PASSWORD} jol > /home/${SUDO_USER}/oldjol.sql
    #backup current old *.in/*.out data
    tar -czvpf /home/${SUDO_USER}/olddata.tar.gz /home/judge/data
    #backup old uploads (images included)
    tar -czvpf /home/${SUDO_USER}/olduploads.tar.gz /home/judge/src/web/upload
    #backup old msg.txt
    tar -czvpf /home/${SUDO_USER}/oldmsg.tar.gz /home/judge/src/web/admin/msg.txt
  fi

  rm -rf /home/judge/src/*
  rm -rf /home/judge/src/.svn
  cd /home/judge/
  wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/${SRCZIP}
  unzip ${SRCZIP}
  rm ${SRCZIP}  

  sed -i "s/DB_USER[[:space:]]*=[[:space:]]*\"root\"/DB_USER=\"$DBUSER\"/g" src/web/include/db_info.inc.php
  sed -i "s/DB_PASS[[:space:]]*=[[:space:]]*\"root\"/DB_PASS=\"$PASSWORD\"/g" src/web/include/db_info.inc.php
  chmod 700 src/web/include/db_info.inc.php
  chown -R www-data src/web/

  chown -R root:root src/web/.svn
  chmod 750 -R src/web/.svn
  chown www-data:judge src/web/upload

else
#new installation block start

echo ""
echo "Waiting 3 seconds..."
echo ""
sleep 3


#for South Korea's timezone
timedatectl set-timezone 'Asia/Seoul'

apt update
apt -y install subversion
apt -y install zip
apt -y install unzip

/usr/sbin/useradd -m -u 1536 judge
cd /home/judge/ || exit

#using tgz src files
#wget -O hustoj.tar.gz http://dl.hustoj.com/hustoj.tar.gz
#tar xzf hustoj.tar.gz
#svn up src
#svn co https://github.com/zhblue/hustoj/trunk/trunk/  src

#how to make src zip
#zip -r hustoj210408.zip ./src
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/${SRCZIP}
unzip ${SRCZIP}
rm ${SRCZIP}

#------ original intallation scripts start




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



#------ original intallation scripts end



#new installation block end
fi



#db_info.inc.php edit
#for OJ NAME
#OJNAME="o"
#INPUTS="x"
#while [ ${OJNAME} != ${INPUTS} ]; do
#  echo -n "Enter  the CSL HUSTOJ name you want : "
#  read OJNAME
#  echo -n "Repeat the CSL HUSTOJ name you want : "
#  read INPUTS
#done
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
if [ ${UPGRADETYPE} = "1" ]
then
  tar -xzvpf /home/${SUDO_USER}/oldmsg.tar.gz -C /
  rm /home/${SUDO_USER}/oldmsg.tar.gz
else
  wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/msg2.txt
  mv -f ./msg2.txt /home/judge/src/web/admin/msg.txt
  sed -i "s/release YY.MM.DD/release ${VER_DATE}/" /home/judge/src/web/admin/msg.txt
fi
chown www-data:$root /home/judge/src/web/admin/msg.txt
chmod 644 /home/judge/src/web/admin/msg.txt

#phpmyadmin install script
#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/phadmin00.sh
#mv -f ./phadmin00.sh /home/${SUDO_USER}/
#chown ${SUDO_USER}:${SUDO_USER} /home/${SUDO_USER}/phadmin00.sh
#chmod 664 /home/${SUDO_USER}/phadmin00.sh

#jol database overwriting
#current mysql backup
#how to backup from HUSTOJ for CSL :> mysqldump -u debian-sys-maint -p jol > jol.sql
#overwriting
DBUSER=$(grep user /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
PASSWORD=$(grep password /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
if [ ${UPGRADETYPE} = "1" ]
then
  mysql -u ${DBUSER} -p${PASSWORD} jol < /home/${SUDO_USER}/oldjol.sql
  rm /home/${SUDO_USER}/oldjol.sql
else
  wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/${SQLFILE}
  mysql -u ${DBUSER} -p${PASSWORD} jol < ${SQLFILE}
  rm ${SQLFILE}
  echo "insert into jol.privilege values('admin','source_browser','true','N');"|mysql -h localhost -u"$USER" -p"$PASSWORD"
fi

#add source_browser privilege to admin #from CSL HUSTOJ 21.04.05

#Coping all uploads to server
#current uploads backup
#how to backup uploads from CSL HUSTOJ
#directory : /home/judge/src/wb/upload/
#command   : sudo tar -czvpf ./${BACKUPS}/upload/olduploads.tar.gz /home/judge/src/web/upload
rm -rf /home/judge/src/web/upload/*
#overwriting
if [ ${UPGRADETYPE} = "1" ]
then
  tar -xzvpf /home/${SUDO_USER}/olduploads.tar.gz -C /
  rm /home/${SUDO_USER}/olduploads.tar.gz
else
  wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/upload/${IMGFILE}
  tar -xzvpf ${IMGFILE} -C /home/judge/src/web/upload/
  rm ${IMGFILE}
fi
chown www-data:www-data -R /home/judge/src/web/upload/*
chmod 644 /home/judge/src/web/upload/*
chmod 755 /home/judge/src/web/upload/image
chown www-data:root -R /home/judge/src/web/upload/index.html
chmod 664 /home/judge/src/web/upload/index.html


#Coping all problem *.in & *.out data to server
#current data backup
#how to backup test in/out files from CSL HUSTOJ
#directory : /home/judge/
#command   : sudo zip -r data.zip ./data
#zip -r ./${BACKUPS}/data.zip /home/judge/data
rm -rf /home/judge/data
#overwriting
if [ ${UPGRADETYPE} = "1" ]
then
  rm -rf /home/judge/data/*
  tar -xzvpf /home/${SUDO_USER}/olddata.tar.gz -C /
  rm /home/${SUDO_USER}/olddata.tar.gz
else
  wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/${DATAFILE}
  unzip ${DATAFILE} -d /home/judge/
  rm ${DATAFILE}
fi
chmod 644 -R /home/judge/data
chown www-data:www-data -R /home/judge/data
chmod 755 /home/judge/data/*
chmod 711 /home/judge/data
chown www-data:judge /home/judge/data


#file upload privelege fix 711 to 644
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/phpfm.php
mv -f ./phpfm.php /home/judge/src/web/admin/
chown www-data:root /home/judge/src/web/admin/phpfm.php
chmod 664 /home/judge/src/web/admin/phpfm.php


#problem_add_page.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_add_page.php
mv -f ./problem_add_page.php /home/judge/src/web/admin/
chown www-data:root /home/judge/src/web/admin/problem_add_page.php
chmod 664 /home/judge/src/web/admin/problem_add_page.php


#problem_add.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_add.php
mv -f ./problem_add.php /home/judge/src/web/admin/
chown www-data:root /home/judge/src/web/admin/problem_add.php
chmod 664 /home/judge/src/web/admin/problem_add.php


#problem_edit.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_edit.php
mv -f ./problem_edit.php /home/judge/src/web/admin/
chown www-data:root /home/judge/src/web/admin/problem_edit.php
chmod 664 /home/judge/src/web/admin/problem_edit.php


#problem_export_xml.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_export_xml.php
mv -f ./problem_export_xml.php /home/judge/src/web/admin/
chown www-data:root /home/judge/src/web/admin/problem_export_xml.php
chmod 664 /home/judge/src/web/admin/problem_export_xml.php


#problem_export.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_export.php
mv -f ./problem_export.php /home/judge/src/web/admin/
chown www-data:root /home/judge/src/web/admin/problem_export.php
chmod 664 /home/judge/src/web/admin/problem_export.php


#problem_import_xml.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_import_xml.php
mv -f ./problem_import_xml.php /home/judge/src/web/admin/
chown www-data:root /home/judge/src/web/admin/problem_import_xml.php
chmod 664 /home/judge/src/web/admin/problem_import_xml.php


#problem_import.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_import.php
mv -f ./problem_import.php /home/judge/src/web/admin/
chown www-data:root /home/judge/src/web/admin/problem_import.php
chmod 664 /home/judge/src/web/admin/problem_import.php


#problem.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/include/problem.php
mv -f ./problem.php /home/judge/src/web/include/
chown www-data:root /home/judge/src/web/include/problem.php
chmod 664 /home/judge/src/web/include/problem.php


#problem.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/problem.php
mv -f ./problem.php /home/judge/src/web/template/bs3/
chown www-data:root /home/judge/src/web/template/bs3/problem.php
chmod 644 /home/judge/src/web/template/bs3/problem.php


#problem.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/submitpage.php
mv -f ./submitpage.php /home/judge/src/web/template/bs3/
chown www-data:root /home/judge/src/web/template/bs3/submitpage.php
chmod 644 /home/judge/src/web/template/bs3/submitpage.php


#submit.php customizing for front, rear, bann, credits fields
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/submit.php
mv -f ./submit.php /home/judge/src/web/
chown www-data:root /home/judge/src/web/submit.php
chmod 644 /home/judge/src/web/submit.php


#set OJ_REGISTER=false
sed -i "s/OJ_REGISTER=true/OJ_REGISTER=false/" /home/judge/src/web/include/db_info.inc.php

#set OJ_VCODE=true
sed -i "s/OJ_VCODE=false/OJ_VCODE=true/" /home/judge/src/web/include/db_info.inc.php

#set OJ_SHOW_DIFF=true
sed -i "s/OJ_SHOW_DIFF=false/OJ_SHOW_DIFF=true/" /home/judge/src/web/include/db_info.inc.php

#set OJ_LANGMASK to  C++ & python only...
sed -i "s/$OJ_LANGMASK=1637684/$OJ_LANGMASK=2097085/" /home/judge/src/web/include/db_info.inc.php

#set OJ_USE_MAX_TIME=1 ... use_max_time
sed -i "s/OJ_USE_MAX_TIME=0/OJ_USE_MAX_TIME=1/" /home/judge/etc/judge.conf


#curl installation
sudo apt -y install curl

#Identifing AWS Ubuntu 20.04 LTS
if [ -f /etc/default/grub.d/50-cloudimg-settings.cfg ]
then
  SERVERTYPES="AWS SERVER"
  IPADDRESS=($(curl http://checkip.amazonaws.com))
else
  SERVERTYPES="LOCAL SERVER"
  IPADDRESS=($(hostname -I))
fi

#Removing QR codes + CSL link
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/js2.php
mv -f ./js2.php /home/judge/src/web/template/bs3/js.php
chown www-data:${SUDO_USER} /home/judge/src/web/template/bs3/js.php
chmod 664 /home/judge/src/web/template/bs3/js.php
sed -i "s/release YY.MM.DD/release ${VER_DATE}/" /home/judge/src/web/template/bs3/js.php

#small fix for status.php
sed -i "s#KB</div># KB</div>#" /home/judge/src/web/status.php
sed -i "s#ms</div># ms</div>#" /home/judge/src/web/status.php

#for python judging error patch
sed -i "s/OJ_RUNNING=1/OJ_RUNNING=4/" /home/judge/etc/judge.conf
sed -i "s/OJ_PYTHON_FREE=0/OJ_PYTHON_FREE=1/" /home/judge/etc/judge.conf

#for contest problem view fix
sed -i "s#\`end_time\`>'\$now' or \`private\`='1'#\`start_time\`<'\$now' AND \`end_time\`>'\$now'#" /home/judge/src/web/problem.php

#for SHOW_DIFF=true error fix in reinfo.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/web/reinfo.php
mv -f ./reinfo.php /home/judge/src/web/reinfo.php
chown www-data:root /home/judge/src/web/reinfo.php
chmod 664 /home/judge/src/web/reinfo.php

#for cslojmaintenance
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/${MAINTENANCEFILE} -O /home/${SUDO_USER}/${MAINTENANCEFILE}
chown ${SUDO_USER}:${SUDO_USER} /home/${SUDO_USER}/${MAINTENANCEFILE}
sed -i "s/\${SUDO_USER}/${SUDO_USER}/g" /home/${SUDO_USER}/${MAINTENANCEFILE}

if [ -e "/var/spool/cron/crontabs/root" ]
then
  if grep "bak.sh" /var/spool/cron/crontabs/root ;
  then
    sed -i "/bak.sh/d" /var/spool/cron/crontabs/root
  fi

  if grep "${MAINTENANCEFILE}" /var/spool/cron/crontabs/root ;
  then
    sed -i "/${MAINTENANCEFILE}/d" /var/spool/cron/crontabs/root
  fi
fi


crontab -l > temp
echo "30 4 * * * sudo bash /home/${SUDO_USER}/${MAINTENANCEFILE}" >> temp
crontab temp
rm -f temp


#temporary fix until next release
sed -i "s/PasswordRest/PasswordReset/" /home/judge/src/web/admin/user_list.php
sed -i "/@session_start();/d" /home/judge/src/web/include/db_info.inc.php
sed -i "s/static  \$OJ_CE_PENALTY/@session_start();\nstatic  \$OJ_CE_PENALTY/" /home/judge/src/web/include/db_info.inc.php


#for backup
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/${BACKUPFILE} -O /home/${SUDO_USER}/${BACKUPFILE}
chown ${SUDO_USER}:${SUDO_USER} /home/${SUDO_USER}/${BACKUPFILE}
sed -i "s/\${SUDO_USER}/${SUDO_USER}/g" /home/${SUDO_USER}/${BACKUPFILE}
bash /home/${SUDO_USER}/${BACKUPFILE} -${VER_DATE}


if [ ${UPGRADETYPE} = "1" ]
then
  echo ""
  echo "---- ${OJNAME}(CSL HUSTOJ release ${VER_DATE}) upgraded! ----"
  echo ""
else
  echo ""
  echo "---- ${OJNAME}(CSL HUSTOJ release ${VER_DATE}) installed! ----"
  echo ""
fi
echo "First of all! Change the default CSL HUSTOJ admin password!"
echo ""
echo "$SERVERTYPES"
echo "http://${IPADDRESS[0]}"
echo ""
