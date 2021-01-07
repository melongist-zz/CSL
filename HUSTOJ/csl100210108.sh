#!/bin/bash
#2021.01.08
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teacher

if [[ -z $SUDO_USER ]] ; then
  echo "Use 'sudo bash csl100210107.sh'"
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

apt update
apt -y upgrade


#phpmyadmin installation
cd
apt -y install phpmyadmin
ln -f -s /usr/share/phpmyadmin /home/judge/src/web/phpmyadmin
mv /home/judge/src/web/phpmyadmin /home/judge/src/web/pma


#make backup directory
cd
BACKUPS=$(`date '+%Y%m%d%H%M'`)
mkdir $BACKUPS

#jol database overwriting
cd
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/csl100v05jol.sql

USER=$(grep user /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
PASSWORD=$(grep password /etc/mysql/debian.cnf|head -1|awk  '{print $3}')

#current mysql backup
mysqldump -u $USER -p$PASSWORD jol > '{$BACKUPS}'jol.sql
cp ./'{$BACKUPS}'jol.sql ~/'{$BACKUPS}'/
#echo "Remember your database account for HUST Online Judge:"
#echo "username:$USER"
#echo "password:$PASSWORD"
#mysqladmin -u $USER -p$PASSWORD create jol
#c.f. : how to backup from HUSTOJ for CSL :> mysqldump -u debian-sys-maint -p jol > csl100v05jol.sql
mysql -u $USER -p$PASSWORD jol < csl100v05jol.sql
rm csl100v05jol.sql


#Coping all problem images to server
cd
cd /home/judge/src/web/upload
#current images backup
tar zcvf '{$BACKUPS}'image.tar.gz
cp ./'{$BACKUPS}'image.tar.gz ~/'{$BACKUPS}'/
rm -rf *
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/upload/csl100v01image.tar.gz
#cf. : how to backup images from HUSTOJ for CSL
#directory : /home/judge/src/web/upload/
#command   : sudo tar zcvf csl100v01image.tar.gz *
tar zxvf csl100v01image.tar.gz
rm csl100v01image.tar.gz


#Coping all problem *.in & *.out data to server
cd
cd /home/judge/
#current data backup
zip -r '{$BACKUPS}'.zip ./data
cp ./'{$BACKUPS}'.zip ./data ~/'{$BACKUPS}'/
rm -rf data
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/csl100v06data.zip
#c.f. : how to backup test files from HUSTOJ for CSL
#directory : /home/judge/
#command   : sudo zip -r csl100v06data.zip ./data
unzip csl100v06data.zip
rm csl100v06data.zip
chmod 644 -R ./data
chown www-data:www-data -R ./data
chmod 755 ./data/*
chmod 711 ./data
chown www-data:judge ./data

#problem_add_page.php customizing for front, rear, bann, credits fields
cd
cd /home/judge/src/web/admin/
rm problem_add_page.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_add_page.php
chown www-data:root problem_add_page.php
chmod 664 problem_add_page.php


#problem_add.php customizing for front, rear, bann, credits fields
cd
cd /home/judge/src/web/admin/
rm problem_add.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_add.php
chown www-data:root problem_add.php
chmod 664 problem_add.php


#problem_edit.php customizing for front, rear, bann, credits fields
cd
cd /home/judge/src/web/admin/
rm problem_edit.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_edit.php
chown www-data:root problem_edit.php
chmod 664 problem_edit.php


#problem_export_xml.php customizing for front, rear, bann, credits fields
cd
cd /home/judge/src/web/admin/
rm problem_export_xml.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_export_xml.php
chown www-data:root problem_export_xml.php
chmod 664 problem_export_xml.php


#problem_export.php customizing for front, rear, bann, credits fields
cd
cd /home/judge/src/web/admin/
rm problem_export.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_export.php
chown www-data:root problem_export.php
chmod 664 problem_export.php


#problem_import_xml.php customizing for front, rear, bann, credits fields
cd
cd /home/judge/src/web/admin/
rm problem_import_xml.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_import_xml.php
chown www-data:root problem_import_xml.php
chmod 664 problem_import_xml.php


#problem_import.php customizing for front, rear, bann, credits fields
cd
cd /home/judge/src/web/admin/
sudo rm problem_import.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_import.php
chown www-data:root problem_import.php
chmod 664 problem_import.php


#problem.php customizing for front, rear, bann, credits fields
cd
cd /home/judge/src/web/include/
rm problem.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/include/problem.php
chown www-data:root problem.php
chmod 664 problem.php


#problem.php customizing for front, rear, bann, credits fields
cd
cd /home/judge/src/web/template/bs3/
rm problem.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/problem.php
chown www-data:root problem.php
chmod 644 problem.php

#problem.php customizing for front, rear, bann, credits fields
cd
cd /home/judge/src/web/template/bs3/
rm submitpage.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/submitpage.php
chown www-data:root submitpage.php
chmod 644 submitpage.php

#submit.php customizing for front, rear, bann, credits fields
cd
cd /home/judge/src/web/
rm submit.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/submit.php
chown www-data:root submit.php
chmod 644 submit.php

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


#time result fix ... for use_max_time : to record the max time of all results, not sum of...
cd
sed -i "s/OJ_USE_MAX_TIME=0/OJ_USE_MAX_TIME=1/" /home/judge/etc/judge.conf


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
cd /home/judge/src/web/admin/
rm msg.txt
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/msg2.txt
mv msg2.txt msg.txt
chown www-data msg.txt
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
