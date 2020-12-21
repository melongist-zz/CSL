#!/bin/bash
#2020.12.21
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teacher

if [[ -z $SUDO_USER ]] ; then
  echo "Use 'sudo bash csl100201221.sh'"
  exit 1
fi

cd

#for South Korea's timezone
sudo timedatectl set-timezone 'Asia/Seoul'

sudo apt update
sudo apt -y upgrade


#phpmyadmin installation
cd
sudo apt -y install phpmyadmin
sudo ln -f -s /usr/share/phpmyadmin /home/judge/src/web/phpmyadmin
sudo mv /home/judge/src/web/phpmyadmin /home/judge/src/web/pma


#jol database overwriting
cd
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/csl100v02jol.sql

USER=$(grep user /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
PASSWORD=$(grep password /etc/mysql/debian.cnf|head -1|awk  '{print $3}')

#echo "Remember your database account for HUST Online Judge:"
#echo "username:$USER"
#echo "password:$PASSWORD"

mysqladmin -u $USER -p$PASSWORD create jol

#c.f. : how to backup from HUSTOJ for CSL :> mysqldump -u debian-sys-maint -p jol > csl100v02jol.sql
mysql -u $USER -p$PASSWORD jol < csl100v02jol.sql
sudo rm csl100v02jol.sql


#Coping all problem images to server
cd
cd /home/judge/src/web/upload
sudo rm -rf *
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/csl100v01image.tar.gz
#cf. : how to backup images from HUSTOJ for CSL
#directory : /home/judge/src/web/upload/
#command   : sudo tar zcvf csl100v01image.tar.gz *
sudo tar zxvf csl100v01image.tar.gz
sudo rm csl100v01image.tar.gz


#Coping all problem *.in & *.out data to server
cd
cd /home/judge/
sudo rm -rf data
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/csl100v01data.tar.gz
#c.f. : how to backup images from HUSTOJ for CSL
#directory : /home/judge/
#command   : sudo tar zcvf csl100v01data.tar.gz data
sudo tar zxvf csl100v01data.tar.gz
sudo rm csl100v01data.tar.gz


#problem_add_page.php customizing for front, rear, bann fields
cd
cd /home/judge/src/web/admin/
sudo rm problem_add_page.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/problem_add_page.php
sudo chown www-data:root problem_add_page.php
sudo chmod 664 problem_add_page.php


#problem_add.php customizing for front, rear, bann fields
cd
cd /home/judge/src/web/admin/
sudo rm problem_add.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/problem_add.php
sudo chown www-data:root problem_add.php
sudo chmod 664 problem_add.php


#problem_edit.php customizing for front, rear, bann fields
cd
cd /home/judge/src/web/admin/
sudo rm problem_edit.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/problem_edit.php
sudo chown www-data:root problem_edit.php
sudo chmod 664 problem_edit.php


#problem_export_xml.php customizing for front, rear, bann fields
cd
cd /home/judge/src/web/admin/
sudo rm problem_export_xml.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/problem_export_xml.php
sudo chown www-data:root problem_export_xml.php
sudo chmod 664 problem_export_xml.php


#problem_export.php customizing for front, rear, bann fields
cd
cd /home/judge/src/web/admin/
sudo rm problem_export.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/problem_export.php
sudo chown www-data:root problem_export.php
sudo chmod 664 problem_export.php


#problem_import_xml.php customizing for front, rear, bann fields
cd
cd /home/judge/src/web/admin/
sudo rm problem_import_xml.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/problem_import_xml.php
sudo chown www-data:root problem_import_xml.php
sudo chmod 664 problem_import_xml.php


#problem_import.php customizing for front, rear, bann fields
cd
cd /home/judge/src/web/admin/
sudo rm problem_import.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/problem_import.php
sudo chown www-data:root problem_import.php
sudo chmod 664 problem_import.php


#problem.php customizing for front, rear, bann fields
cd
cd /home/judge/src/web/include/
sudo rm problem.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/problem.php
sudo chown www-data:root problem.php
sudo chmod 664 problem.php


#submit.php customizing for front, rear, bann fields
cd
cd /home/judge/src/web/
sudo rm submit.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/submit.php
sudo chown www-data:root submit.php
sudo chmod 644 submit.php


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
sudo rm msg.txt
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/msg2.txt
sudo mv msg2.txt msg.txt
sudo chown www-data msg.txt
cd

clear

echo ""
echo "--- CSL 300 problems installed ---"
echo ""
echo "First of all! : Change admin password!"
echo ""
echo "$SERVERTYPES"
echo "http://${IPADDRESS[0]}"
echo ""
echo "Check & Edit HUSTOJ configurations"
echo "sudo vi /home/judge/src/web/include/db_info.inc.php"
echo ""
echo "This Script is..."
echo "Made by melongist(what_is_computer@msn.com)"
echo "And supported by CSL"
