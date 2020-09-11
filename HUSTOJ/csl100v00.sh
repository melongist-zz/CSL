#!/bin/bash

sudo apt update
sudo apt upgrade

#kindeditor korean setting
cd /home/judge/src/web/admin/
sudo rm kindeditor.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/kindeditor.php
sudo chown www-data kindeditor.php

#front, rear, bann setting
cd /home/judge/src/web/
sudo rm submit.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/submit.php
sudo chown www-data submit.php

#QR codes removing + CSL link
cd /home/judge/src/web/template/bs3/
sudo rm js.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/js.php
sudo chown www-data js.php

#replace msg.txt
cd /home/judge/src/web/admin/
sudo rm msg.txt
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/msg.txt
sudo chown www-data msg.txt

#copy all images to server
cd /home/judge/src/web/upload
sudo rm -rf *
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/csl100v00image.tar.gz
sudo tar zxvf csl100v00image.tar.gz
sudo rm csl100v00image.tar.gz

#copy all data to server
cd /home/judge/
sudo rm -rf data
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/csl100v00data.tar.gz
sudo tar zxvf csl100v00data.tar.gz
sudo rm csl100v00data.tar.gz

#install phpmyadmin
cd
sudo apt install phpmyadmin
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
mysql -u $USER -p$PASSWORD jol < csl100v00jol.sql
sudo rm csl100v00jol.sql

clear
echo "Ver 2020.09.11"
echo "CSL 100 problems install completed!!"


#db_info.inc.php edit
cd /home/judge/src/web/include

#OJ NAME
INPUTS="n"
OJNAME=""
while [ ${INPUTS} = "n" ]; do
  echo -n "OJ NAME?: "
  read OJNAME
  echo -n "OJ NAME : $OJNAME     OK?[y/n] "
  read INPUTS
done
sed -i "s/OJ_NAME=\"HUSTOJ\"/OJ_NAME=\"${OJNAME}\"/" db_info.inc.php

#for korean
sed -i "s/OJ_LANG=\"en\"/OJ_LANG=\"ko\"/" db_info.inc.php

#for OJ_VCODE
sed -i "s/OJ_VCODE=false/OJ_VCODE=true/" db_info.inc.php

#for unable to new register
sed -i "s/OJ_REGISTER=true/OJ_REGISTER=false/" db_info.inc.php

#for OJ_SHOW_DIFF
INPUTS="n"
while [ ${INPUTS} = "n" ]; do
  echo -n "OJ_SHOW_DIFF=true    OK?[y/n] "
  read INPUTS
  if [ ${INPUTS} = "y" ]; then
    sed -i "s/OJ_SHOW_DIFF=false/OJ_SHOW_DIFF=true/" db_info.inc.php
  else  
    echo -n "OJ_SHOW_DIFF=false   OK?[y/n] "
    read INPUTS
  fi
done

#for south korea timezone
sed -i "s#//date_default_timezone_set(\"PRC\")#date_default_timezone_set(\"Asia\/Seoul\")#" db_info.inc.php
sed -i "s#//pdo_query(\"SET time_zone ='+8:00'\")#pdo_query(\"SET time_zone ='+9:00'\")#" db_info.inc.php

cd

echo "/home/judge/src/web/include/db_info.inc.php edited!!"
echo "Edit /home/judge/src/web/include/db_info.inc.php for more options!!"
echo ""
echo "$OJNAME   admin ID : admin"
echo "$OJNAME   admin PW : computerscience"
echo ""
echo "Log in as admin and change PW!"
echo ""
echo "Made by melongist(what_is_computer@msn.com)"
echo "Powered by CSL"
