#!/bin/bash
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teacher

VER_DATE="2021.01.09"

THISFILE="csl100210109.sh"

SQLFILE="csl100v05jol.sql"
IMGFILE="csl100v01image.tar.gz"
DATAFILE="csl100v06data.zip"

cd

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash ${THISFILE}'"
  exit 1
fi

sudo apt update
sudo apt -y upgrade
sudo apt -y autoremove

clear

echo ""
echo "---- CSL(Computer Science teachers's computer science Love) ----"
echo ""

#Confirmation
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

BACKUPS=$(echo `date '+%Y%m%d%H%M'`)
mkdir ${BACKUPS}
mkdir ${BACKUPS}/admin/
mkdir ${BACKUPS}/bs3/
mkdir ${BACKUPS}/include/
mkdir ${BACKUPS}/upload/

echo ""
echo "Current jol DB(sql dump), image files, data(*.in, *.out) files will be backup..."
echo "~/${BACKUPS}"
echo ""
echo ""

#jol database overwriting
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/${SQLFILE}
DBUSER=$(sudo grep user /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
PASSWORD=$(sudo grep password /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
#current mysql backup
#c.f. : how to backup from HUSTOJ for CSL :> mysqldump -u debian-sys-maint -p jol > jol.sql
mysqldump -u ${DBUSER} -p$PASSWORD jol > ./${BACKUPS}/jol.sql
#overwrting
mysql -u ${DBUSER} -p${PASSWORD} jol < ${SQLFILE}
rm ${SQLFILE}

#Coping all problem images to server
#current images backup
#cf. : how to backup images from HUSTOJ for CSL
#directory : /home/judge/src/web/upload/
#command   : sudo tar zcvf csl100v01image.tar.gz *
sudo tar zcvf ./${BACKUPS}/upload/images.tar.gz /home/judge/src/web/upload/*
sudo rm -rf /home/judge/src/web/upload/*
#overwriting
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/upload/${IMGFILE}
sudo tar zxvf ${IMGFILE} -C /home/judge/src/web/upload/
rm ${IMGFILE}
sudo chown www-data:www-data -R /home/judge/src/web/upload/*
sudo chmod 644 /home/judge/src/web/upload/*
sudo chmod 755 /home/judge/src/web/upload/image
sudo chown www-data:root -R /home/judge/src/web/upload/index.html
sudo chmod 664 /home/judge/src/web/upload/index.html

#Coping all problem *.in & *.out data to server
#current data backup
#c.f. : how to backup test files from HUSTOJ for CSL
#directory : /home/judge/
#command   : sudo zip -r data.zip ./data
sudo zip -r ./${BACKUPS}/data.zip /home/judge/data
sudo rm -rf /home/judge/data
#overwriting
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/${DATAFILE}
sudo unzip ${DATAFILE} -d /home/judge/
rm ${DATAFILE}
sudo chmod 644 -R /home/judge/data
sudo chown www-data:www-data -R /home/judge/data
sudo chmod 755 /home/judge/data/*
sudo chmod 711 /home/judge/data
sudo chown www-data:judge /home/judge/data


#problem_add_page.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/admin/problem_add_page.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_add_page.php
sudo mv -f ./problem_add_page.php /home/judge/src/web/admin/
sudo chown www-data:root /home/judge/src/web/admin/problem_add_page.php
sudo chmod 664 /home/judge/src/web/admin/problem_add_page.php

#problem_add.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/admin/problem_add.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_add.php
sudo mv -f ./problem_add.php /home/judge/src/web/admin/
sudo chown www-data:root /home/judge/src/web/admin/problem_add.php
sudo chmod 664 /home/judge/src/web/admin/problem_add.php

#problem_edit.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/admin/problem_edit.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_edit.php
sudo mv -f ./problem_edit.php /home/judge/src/web/admin/
sudo chown www-data:root /home/judge/src/web/admin/problem_edit.php
sudo chmod 664 /home/judge/src/web/admin/problem_edit.php

#problem_export_xml.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/admin/problem_export_xml.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_export_xml.php
sudo mv -f ./problem_export_xml.php /home/judge/src/web/admin/
sudo chown www-data:root /home/judge/src/web/admin/problem_export_xml.php
sudo chmod 664 /home/judge/src/web/admin/problem_export_xml.php

#problem_export.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/admin/problem_export.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_export.php
sudo mv -f ./problem_export.php /home/judge/src/web/admin/
sudo chown www-data:root /home/judge/src/web/admin/problem_export.php
sudo chmod 664 /home/judge/src/web/admin/problem_export.php

#problem_import_xml.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/admin/problem_import_xml.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_import_xml.php
sudo mv -f ./problem_import_xml.php /home/judge/src/web/admin/
sudo chown www-data:root /home/judge/src/web/admin/problem_import_xml.php
sudo chmod 664 /home/judge/src/web/admin/problem_import_xml.php

#problem_import.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/admin/problem_import.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_import.php
sudo mv -f ./problem_import.php /home/judge/src/web/admin/
sudo chown www-data:root /home/judge/src/web/admin/problem_import.php
sudo chmod 664 /home/judge/src/web/admin/problem_import.php

#problem.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/include/problem.php ./${BACKUPS}/include/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/include/problem.php
sudo mv -f ./problem.php /home/judge/src/web/include/
sudo chown www-data:root /home/judge/src/web/include/problem.php
sudo chmod 664 /home/judge/src/web/include/problem.php

#problem.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/template/bs3/problem.php ./${BACKUPS}/bs3/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/problem.php
sudo mv -f ./problem.php /home/judge/src/web/template/bs3/
sudo chown www-data:root /home/judge/src/web/template/bs3/problem.php
sudo chmod 644 /home/judge/src/web/template/bs3/problem.php

#problem.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/template/bs3/submitpage.php ./${BACKUPS}/bs3/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/submitpage.php
sudo mv -f ./submitpage.php /home/judge/src/web/template/bs3/
sudo chown www-data:root /home/judge/src/web/template/bs3/submitpage.php
sudo chmod 644 /home/judge/src/web/template/bs3/submitpage.php

#submit.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/submit.php ./${BACKUPS}/bs3/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/submit.php
sudo mv -f ./submit.php /home/judge/src/web/
sudo chown www-data:root /home/judge/src/web/submit.php
sudo chmod 644 /home/judge/src/web/submit.php

clear


#HUSTOJ db_info.inc.php settings
sudo cp /home/judge/src/web/include/db_info.inc.php ./${BACKUPS}/include/

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


#result time fix ... use_max_time
sudo cp /home/judge/etc/judge.conf ./${BACKUPS}/
sudo sed -i "s/OJ_USE_MAX_TIME=0/OJ_USE_MAX_TIME=1/" /home/judge/etc/judge.conf


#phpmyadmin installation
if [ -f /usr/share/phpmyadmin ]; then
  echo "phpmyadmin already installed!"
else
  sudo apt -y install phpmyadmin
  sudo ln -f -s /usr/share/phpmyadmin /home/judge/src/web/phpmyadmin
  sudo mv /home/judge/src/web/phpmyadmin /home/judge/src/web/pma
fi

#curl installation
sudo apt -y install curl


#Identifing AWS Ubuntu 20.04 LTS
if [ -f /etc/default/grub.d/50-cloudimg-settings.cfg ]; then
  SERVERTYPES="AWS SERVER"
  IPADDRESS=($(sudo curl http://checkip.amazonaws.com))
else
  SERVERTYPES="LOCAL SERVER"
  IPADDRESS=($(sudo hostname -I))
fi

clear

#Replacing msg.txt
sudo mv -f /home/judge/src/web/admin/msg.txt ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/msg2.txt
sudo mv -f ./msg2.txt /home/judge/src/web/admin/msg.txt
sudo chown www-data:root /home/judge/src/web/admin/msg.txt
sudo chmod 644 /home/judge/src/web/admin/msg.txt

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

