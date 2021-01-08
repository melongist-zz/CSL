#!/bin/bash
#2021.01.08
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teacher

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash csl100210108.sh'"
  exit 1
fi

clear

echo ""
echo "---- CSL(Computer Science teachers's computer science Love) ----"
echo ""

#Confirm
INPUTS="n"
while [ ${INPUTS} = "n" ]; do
  echo -n "All data and database will be overwritten. Are you sure?[y/n] "
  read INPUTS
  if [ ${INPUTS} = "y" ]; then
    echo -n "CSL Basic 100s problems will be installed. Are you sure?[y/n] "
    read INPUTS
    if [ ${INPUTS} = "n" ]; then
      echo "CSL Basic 100s problems installation canceled!!"
      exit 1
    fi
  else  
    echo "CSL Basic 100s problems installation canceled!!"
    exit 1
  fi
done

echo ""
echo ""

cd

#for South Korea's timezone
timedatectl set-timezone 'Asia/Seoul'

sudo apt update
sudo apt -y upgrade


#phpmyadmin installation
cd
sudo apt -y install phpmyadmin
sudo ln -f -s /usr/share/phpmyadmin /home/judge/src/web/phpmyadmin
sudo mv /home/judge/src/web/phpmyadmin /home/judge/src/web/pma

#backup name
BACKUPS=$(echo `date '+%Y%m%d%H%M'`)

#jol database overwriting
cd
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/csl100v05jol.sql

DBUSER=$(grep user /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
PASSWORD=$(grep password /etc/mysql/debian.cnf|head -1|awk  '{print $3}')

#current mysql backup
mysqldump -u $DBUSER -p$PASSWORD jol > ${BACKUPS}jolbackup.sql

#echo "Remember your database account for HUST Online Judge:"
#echo "username:$USER"
#echo "password:$PASSWORD"
#mysqladmin -u $USER -p$PASSWORD create jol
#c.f. : how to backup from HUSTOJ for CSL :> mysqldump -u debian-sys-maint -p jol > csl100v05jol.sql
mysql -u $DBUSER -p$PASSWORD jol < csl100v05jol.sql
rm csl100v05jol.sql


#Coping all problem images to server
cd
#current images backup
sudo tar zcvf ./${BACKUPS}imagebackup.tar.gz /home/judge/src/web/upload/*
sudo rm -rf /home/judge/src/web/upload/*
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/upload/csl100v01image.tar.gz
#cf. : how to backup images from HUSTOJ for CSL
#directory : /home/judge/src/web/upload/
#command   : sudo tar zcvf csl100v01image.tar.gz *
sudo tar zxvf ./csl100v01image.tar.gz /home/judge/src/web/upload/
rm csl100v01image.tar.gz


#Coping all problem *.in & *.out data to server
cd
#current data backup
sudo zip -r ./${BACKUPS}databackup.zip /home/judge/data
sudo rm -rf /home/judge/data
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/csl100v06data.zip
#c.f. : how to backup test files from HUSTOJ for CSL
#directory : /home/judge/
#command   : sudo zip -r csl100v06data.zip ./data
sudo unzip ./csl100v06data.zip /home/judge/
rm csl100v06data.zip
chmod 644 -R /home/judge/data
chown www-data:www-data -R /home/judge/data
chmod 755 /home/judge/data/*
chmod 711 /home/judge/data
chown www-data:judge /home/judge/data

#problem_add_page.php customizing for front, rear, bann, credits fields
cd
sudo rm /home/judge/src/web/admin/problem_add_page.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_add_page.php
sudo mv ./problem_add_page.php /home/judge/src/web/admin/
sudo chown www-data:root /home/judge/src/web/admin/problem_add_page.php
sudo chmod 664 /home/judge/src/web/admin/problem_add_page.php


#problem_add.php customizing for front, rear, bann, credits fields
cd
sudo rm /home/judge/src/web/admin/problem_add.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_add.php
sudo mv ./problem_add.php /home/judge/src/web/admin/
sudo chown www-data:root /home/judge/src/web/admin/problem_add.php
sudo chmod 664 /home/judge/src/web/admin/problem_add.php


#problem_edit.php customizing for front, rear, bann, credits fields
cd
sudo rm /home/judge/src/web/admin/problem_edit.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_edit.php
sudo mv ./problem_edit.php /home/judge/src/web/admin/
sudo chown www-data:root /home/judge/src/web/admin/problem_edit.php
sudo chmod 664 /home/judge/src/web/admin/problem_edit.php


#problem_export_xml.php customizing for front, rear, bann, credits fields
cd
sudo rm /home/judge/src/web/admin/problem_export_xml.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_export_xml.php
sudo mv ./problem_export_xml.php /home/judge/src/web/admin/
chown www-data:root /home/judge/src/web/admin/problem_export_xml.php
chmod 664 /home/judge/src/web/admin/problem_export_xml.php


#problem_export.php customizing for front, rear, bann, credits fields
cd
sudo rm /home/judge/src/web/admin/problem_export.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_export.php
sudo mv ./problem_export.php /home/judge/src/web/admin/
sudo chown www-data:root /home/judge/src/web/admin/problem_export.php
sudo chmod 664 /home/judge/src/web/admin/problem_export.php


#problem_import_xml.php customizing for front, rear, bann, credits fields
cd
sudo rm /home/judge/src/web/admin/problem_import_xml.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_import_xml.php
sudo mv ./problem_import_xml.php /home/judge/src/web/admin/
sudo chown www-data:root /home/judge/src/web/admin/problem_import_xml.php
sudo chmod 664 /home/judge/src/web/admin/problem_import_xml.php


#problem_import.php customizing for front, rear, bann, credits fields
cd
sudo rm /home/judge/src/web/admin/problem_import.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_import.php
sudo mv ./problem_import.php /home/judge/src/web/admin/
sudo chown www-data:root /home/judge/src/web/admin/problem_import.php
sudo chmod 664 /home/judge/src/web/admin/problem_import.php


#problem.php customizing for front, rear, bann, credits fields
cd
sudo rm /home/judge/src/web/include/problem.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/include/problem.php
sudo mv ./probmem.php /home/judge/src/web/include/
sudo chown www-data:root /home/judge/src/web/include/problem.php
sudo chmod 664 /home/judge/src/web/include/problem.php


#problem.php customizing for front, rear, bann, credits fields
cd
sudo rm /home/judge/src/web/template/bs3/problem.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/problem.php
sudo mv ./problem.php /home/judge/src/web/template/bs3/
sudo chown www-data:root /home/judge/src/web/template/bs3/problem.php
sudo chmod 644 /home/judge/src/web/template/bs3/problem.php

#problem.php customizing for front, rear, bann, credits fields
cd
sudo rm /home/judge/src/web/template/bs3/submitpage.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/submitpage.php
sudo mv ./submitpage.php /home/judge/src/web/template/bs3/
sudo chown www-data:root /home/judge/src/web/template/bs3/submitpage.php
sudo chmod 644 /home/judge/src/web/template/bs3/submitpage.php

#submit.php customizing for front, rear, bann, credits fields
cd
sudo rm /home/judge/src/web/submit.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/submit.php
sudo mv ./submit.php /home/judge/src/web/
chown www-data:root /home/judge/src/web/submit.php
chmod 644 /home/judge/src/web/submit.php

#HUSTOJ db_info.inc.php settings
cd

clear

echo ""
echo "--- db_info.inc.php options ---"
echo ""

#for able/unable to register
INPUTS="n"
while [ ${INPUTS} = "n" ]; do
  echo -n "OJ_REGISTER=false    OK?[y/n] "
  read INPUTS
  if [ ${INPUTS} = "y" ]; then
    sudo sed -i "s/OJ_REGISTER=true/OJ_REGISTER=false/" /home/judge/src/web/include/db_info.inc.php
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
    sudo sed -i "s/OJ_VCODE=false/OJ_VCODE=true/" /home/judge/src/web/include/db_info.inc.php
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
    sudo sed -i "s/OJ_SHOW_DIFF=false/OJ_SHOW_DIFF=true/" /home/judge/src/web/include/db_info.inc.php
  else  
    echo -n "OJ_SHOW_DIFF=false   OK?[y/n] "
    read INPUTS
  fi
done


#time result fix ... for use_max_time : to record the max time of all results, not sum of...
cd
sudo sed -i "s/OJ_USE_MAX_TIME=0/OJ_USE_MAX_TIME=1/" /home/judge/etc/judge.conf


cd
sudo apt -y autoremove

#Identifing AWS Ubuntu 20.04 LTS
if [ -f /etc/default/grub.d/50-cloudimg-settings.cfg ]; then
  SERVERTYPES="AWS SERVER"
  IPADDRESS=($(curl http://checkip.amazonaws.com))
else
  SERVERTYPES="LOCAL SERVER"
  IPADDRESS=($(hostname -I))
fi

clear

#Replacing msg.txt
sudo rm /home/judge/src/web/admin/msg.txt
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/msg2.txt
sudo mv ./msg2.txt /home/judge/src/web/admin/msg.txt
chown www-data /home/judge/src/web/admin/msg.txt
cd

clear

echo ""
echo "--- CSL Basic 100s problems installed ---"
echo ""
echo "First of all! : Change admin password!"
echo ""
echo "$SERVERTYPES"
echo "http://${IPADDRESS[0]}"
echo ""
echo "Check & Edit HUSTOJ configurations"
echo "sudo vi /home/judge/src/web/include/db_info.inc.php"
echo ""
echo "This Script is supported by CSL(South Korea CSTA)"
