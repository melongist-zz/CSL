#!/bin/bash
#CSL Basic 100s problems installation script for HUSTOJ
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teacher

VER_DATE="2021.01.10"

THISFILE="csl100210110.sh"
RESTOREFILE="restore.sh"

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
  echo -n "All HUSTOJ data and database will be overwritten. Are you sure?[y/n] "
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
BACKUPS+="u"
mkdir ${BACKUPS}
mkdir ${BACKUPS}/admin/
mkdir ${BACKUPS}/bs3/
mkdir ${BACKUPS}/include/
mkdir ${BACKUPS}/upload/

cp ${THISFILE} ./${BACKUPS}/
touch ./${BACKUPS}/${RESTOREFILE}
echo "clear" >> ./${BACKUPS}/${RESTOREFILE}
echo "if [[ \$SUDO_USER ]] ; then" >> ./${BACKUPS}/${RESTOREFILE}
echo "  echo \"Just use 'bash ${RESTOREFILE}'\"" >> ./${BACKUPS}/${RESTOREFILE}
echo "  exit 1" >> ./${BACKUPS}/${RESTOREFILE}
echo "fi" >> ./${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> ./${BACKUPS}/${RESTOREFILE}
echo "echo \"---- CSL(Computer Science teachers's computer science Love) ----\"" >> ./${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> ./${BACKUPS}/${RESTOREFILE}
echo "INPUTS=\"n\"" >> ./${BACKUPS}/${RESTOREFILE}
echo "echo -n \"This script will restore \${BACKUPS} backups. Are you sure?[y/n] \"" >> ./${BACKUPS}/${RESTOREFILE}
echo "read INPUTS" >> ./${BACKUPS}/${RESTOREFILE}
echo "if [ \${INPUTS} = \"n\" ]; then" >> ./${BACKUPS}/${RESTOREFILE}
echo "  exit 1" >> ./${BACKUPS}/${RESTOREFILE}
echo "fi" >> ./${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> ./${BACKUPS}/${RESTOREFILE}


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
mysqldump -u ${DBUSER} -p$PASSWORD jol >> ./${BACKUPS}/jol.sql
#overwrting
mysql -u ${DBUSER} -p${PASSWORD} jol < ${SQLFILE}
rm ${SQLFILE}
#for restoring
echo "DBUSER=\$(sudo grep user /etc/mysql/debian.cnf|head -1|awk  '{print \$3}')" >> ./${BACKUPS}/${RESTOREFILE}
echo "PASSWORD=\$(sudo grep password /etc/mysql/debian.cnf|head -1|awk  '{print \$3}')" >> ./${BACKUPS}/${RESTOREFILE}
echo "mysql -u \${DBUSER} -p\${PASSWORD} jol < jol.sql" >> ./${BACKUPS}/${RESTOREFILE}

#Coping all problem images to server
#current images backup
#cf. : how to backup images from HUSTOJ for CSL
#directory : /home/judge/src/wb/upload/
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
#for restoring
echo "sudo rm -rf /home/judge/src/web/upload/*" >> ./${BACKUPS}/${RESTOREFILE}
echo "sudo tar zxvf ./upload/images.tar.gz -C /home/judge/src/web/upload/" >> ./${BACKUPS}/${RESTOREFILE}

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
#for restoring
echo "sudo rm -rf /home/judge/data" >> ./${BACKUPS}/${RESTOREFILE}
echo "sudo unzip ./data.zip -d /home/judge/" >> ./${BACKUPS}/${RESTOREFILE}

#problem_add_page.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/admin/problem_add_page.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_add_page.php
sudo mv -f ./problem_add_page.php /home/judge/src/web/admin/
sudo chown www-data:root /home/judge/src/web/admin/problem_add_page.php
sudo chmod 664 /home/judge/src/web/admin/problem_add_page.php
#for restoring
echo "sudo cp -f ./admin/problem_add_page.php /home/judge/src/web/admin/" >> ./${BACKUPS}/${RESTOREFILE}

#problem_add.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/admin/problem_add.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_add.php
sudo mv -f ./problem_add.php /home/judge/src/web/admin/
sudo chown www-data:root /home/judge/src/web/admin/problem_add.php
sudo chmod 664 /home/judge/src/web/admin/problem_add.php
#for restoring
echo "sudo cp -f ./admin/problem_add.php /home/judge/src/web/admin/" >> ./${BACKUPS}/${RESTOREFILE}

#problem_edit.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/admin/problem_edit.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_edit.php
sudo mv -f ./problem_edit.php /home/judge/src/web/admin/
sudo chown www-data:root /home/judge/src/web/admin/problem_edit.php
sudo chmod 664 /home/judge/src/web/admin/problem_edit.php
#for restoring
echo "sudo cp -f ./admin/problem_edit.php /home/judge/src/web/admin/" >> ./${BACKUPS}/${RESTOREFILE}

#problem_export_xml.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/admin/problem_export_xml.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_export_xml.php
sudo mv -f ./problem_export_xml.php /home/judge/src/web/admin/
sudo chown www-data:root /home/judge/src/web/admin/problem_export_xml.php
sudo chmod 664 /home/judge/src/web/admin/problem_export_xml.php
#for restoring
echo "sudo cp -f ./admin/problem_export_xml.php /home/judge/src/web/admin/" >> ./${BACKUPS}/${RESTOREFILE}

#problem_export.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/admin/problem_export.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_export.php
sudo mv -f ./problem_export.php /home/judge/src/web/admin/
sudo chown www-data:root /home/judge/src/web/admin/problem_export.php
sudo chmod 664 /home/judge/src/web/admin/problem_export.php
#for restoring
echo "sudo cp -f ./admin/problem_export.php /home/judge/src/web/admin/" >> ./${BACKUPS}/${RESTOREFILE}

#problem_import_xml.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/admin/problem_import_xml.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_import_xml.php
sudo mv -f ./problem_import_xml.php /home/judge/src/web/admin/
sudo chown www-data:root /home/judge/src/web/admin/problem_import_xml.php
sudo chmod 664 /home/judge/src/web/admin/problem_import_xml.php
#for restoring
echo "sudo cp -f ./admin/problem_import_xml.php /home/judge/src/web/admin/" >> ./${BACKUPS}/${RESTOREFILE}

#problem_import.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/admin/problem_import.php ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/admin/problem_import.php
sudo mv -f ./problem_import.php /home/judge/src/web/admin/
sudo chown www-data:root /home/judge/src/web/admin/problem_import.php
sudo chmod 664 /home/judge/src/web/admin/problem_import.php
#for restoring
echo "sudo cp -f ./admin/problem_import.php /home/judge/src/web/admin/" >> ./${BACKUPS}/${RESTOREFILE}

#problem.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/include/problem.php ./${BACKUPS}/include/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/include/problem.php
sudo mv -f ./problem.php /home/judge/src/web/include/
sudo chown www-data:root /home/judge/src/web/include/problem.php
sudo chmod 664 /home/judge/src/web/include/problem.php
#for restoring
echo "sudo cp -f ./include/problem.php /home/judge/src/web/include/" >> ./${BACKUPS}/${RESTOREFILE}

#problem.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/template/bs3/problem.php ./${BACKUPS}/bs3/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/problem.php
sudo mv -f ./problem.php /home/judge/src/web/template/bs3/
sudo chown www-data:root /home/judge/src/web/template/bs3/problem.php
sudo chmod 644 /home/judge/src/web/template/bs3/problem.php
#for restoring
echo "sudo cp -f ./bs3/problem.php /home/judge/src/web/template/bs3/" >> ./${BACKUPS}/${RESTOREFILE}

#problem.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/template/bs3/submitpage.php ./${BACKUPS}/bs3/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/bs3/submitpage.php
sudo mv -f ./submitpage.php /home/judge/src/web/template/bs3/
sudo chown www-data:root /home/judge/src/web/template/bs3/submitpage.php
sudo chmod 644 /home/judge/src/web/template/bs3/submitpage.php
#for restoring
echo "sudo cp -f ./bs3/submitpage.php /home/judge/src/web/template/bs3/" >> ./${BACKUPS}/${RESTOREFILE}

#submit.php customizing for front, rear, bann, credits fields
sudo mv -f /home/judge/src/web/submit.php ./${BACKUPS}/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/submit.php
sudo mv -f ./submit.php /home/judge/src/web/
sudo chown www-data:root /home/judge/src/web/submit.php
sudo chmod 644 /home/judge/src/web/submit.php
#for restoring
echo "sudo cp -f ./submit.php /home/judge/src/web/" >> ./${BACKUPS}/${RESTOREFILE}

clear


#HUSTOJ db_info.inc.php settings
sudo cp /home/judge/src/web/include/db_info.inc.php ./${BACKUPS}/include/
#for restoring
echo "sudo cp -f ./include/db_info.inc.php /home/judge/src/web/include/" >> ./${BACKUPS}/${RESTOREFILE}


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
#for restoring
echo "sudo cp -f ./judge.conf /home/judge/etc/" >> ./${BACKUPS}/${RESTOREFILE}


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

#Removing QR codes + CSL link
sudo mv -f /home/judge/src/web/template/bs3/js.php ./${BACKUPS}/bs3/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/js2.php
mv -f ./js2.php /home/judge/src/web/template/bs3/js.php
chown www-data:${SUDO_USER} /home/judge/src/web/template/bs3/js.php
chmod 664 /home/judge/src/web/template/bs3/js.php
#for restoring
echo "sudo cp -f ./bs3/js.php /home/judge/src/web/template/bs3/" >> ./${BACKUPS}/${RESTOREFILE}

#Replacing msg.txt
sudo mv -f /home/judge/src/web/admin/msg.txt ./${BACKUPS}/admin/
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/msg2.txt
sudo mv -f ./msg2.txt /home/judge/src/web/admin/msg.txt
sudo chown www-data:root /home/judge/src/web/admin/msg.txt
sudo chmod 644 /home/judge/src/web/admin/msg.txt
#for restoring
echo "sudo cp -f ./admin/msg.txt /home/judge/src/web/admin/" >> ./${BACKUPS}/${RESTOREFILE}
echo "clear" >> ./${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> ./${BACKUPS}/${RESTOREFILE}
echo "echo \"HUSTOJ ${BACKUPS} successfully restored!\"" >> ./${BACKUPS}/${RESTOREFILE} 
echo "echo \"\"" >> ./${BACKUPS}/${RESTOREFILE}

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

