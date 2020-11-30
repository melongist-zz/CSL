#!/bin/bash
#2020.12.01

if [[ -z $SUDO_USER ]] ; then
  echo "Use 'sudo bash csl100v10.sh'"
  exit 1
fi

cd

#for South Korea's timezone
sudo timedatectl set-timezone 'Asia/Seoul'

sudo apt update
sudo apt -y upgrade

#front, rear, bann setting
cd /home/judge/src/web/
sudo rm submit.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/submit.php
sudo chown www-data submit.php

#copy all images to server
cd /home/judge/src/web/upload
sudo rm -rf *
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/csl100v00image.tar.gz
#c.f. : how to backup images from HUSTOJ for CSL
#directory : /home/judge/src/web/upload/
#command   : sudo tar zcvf csl100v00image.tar.gz *
sudo tar zxvf csl100v00image.tar.gz
sudo rm csl100v00image.tar.gz

#copy all data to server
cd /home/judge/
sudo rm -rf data
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/csl100v00data.tar.gz
#c.f. : how to backup images from HUSTOJ for CSL
#directory : /home/judge/
#command   : sudo tar zcvf csl100v00data.tar.gz data
sudo tar zxvf csl100v00data.tar.gz
sudo rm csl100v00data.tar.gz

#install phpmyadmin
cd
sudo apt -y install phpmyadmin
sudo ln -f -s /usr/share/phpmyadmin /home/judge/src/web/phpmyadmin
sudo mv /home/judge/src/web/phpmyadmin /home/judge/src/web/pma

#sql overwriting
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/csl100v00jol.sql

USER=$(grep user /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
PASSWORD=$(grep password /etc/mysql/debian.cnf|head -1|awk  '{print $3}')

#echo "Remember your database account for HUST Online Judge:"
#echo "username:$USER"
#echo "password:$PASSWORD"

mysqladmin -u $USER -p$PASSWORD create jol

#c.f. : how to backup from HUSTOJ for CSL :> mysqldump -u debian-sys-maint -p jol > csl100v00jol.sql
mysql -u $USER -p$PASSWORD jol < csl100v00jol.sql
sudo rm csl100v00jol.sql

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

clear


#replace msg.txt
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
echo "Made by melongist(what_is_computer@msn.com)"
echo "Powered by CSL"
