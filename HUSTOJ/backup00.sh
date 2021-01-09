#!/bin/bash
#backup script for HUSTOJ
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teacher

VER_DATE="2021.01.09"

THISFILE="backup00.sh"
RESTOREFILE="restore.sh"

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
echo "Current jol DB(sql dump), image files, data(*.in, *.out) files will be backup."
echo -n "Are you sure?[y/n] "
read INPUTS
if [ ${INPUTS} = "n" ]; then
  exit 1
fi

echo ""

BACKUPS=$(echo `date '+%Y%m%d%H%M'`)
BACKUPS+="b"
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
echo "jol DB(sql dump), image files, data(*.in, *.out) files will be backup..."
echo "~/${BACKUPS}"
echo ""
echo ""

#current mysql backup
#c.f. : how to backup from HUSTOJ for CSL :> mysqldump -u debian-sys-maint -p jol > jol.sql
mysqldump -u ${DBUSER} -p$PASSWORD jol >> ./${BACKUPS}/jol.sql
#for restoring
echo "DBUSER=\$(sudo grep user /etc/mysql/debian.cnf|head -1|awk  '{print \$3}')" >> ./${BACKUPS}/${RESTOREFILE}
echo "PASSWORD=\$(sudo grep password /etc/mysql/debian.cnf|head -1|awk  '{print \$3}')" >> ./${BACKUPS}/${RESTOREFILE}
echo "mysql -u \${DBUSER} -p\${PASSWORD} jol < jol.sql" >> ./${BACKUPS}/${RESTOREFILE}

#current images backup
#cf. : how to backup images from HUSTOJ for CSL
#directory : /home/judge/src/wb/upload/
#command   : sudo tar zcvf csl100v01image.tar.gz *
sudo tar zcvf ./${BACKUPS}/upload/images.tar.gz /home/judge/src/web/upload/*
#for restoring
echo "sudo rm -rf /home/judge/src/web/upload/*" >> ./${BACKUPS}/${RESTOREFILE}
echo "sudo tar zxvf ./upload/images.tar.gz -C /home/judge/src/web/upload/" >> ./${BACKUPS}/${RESTOREFILE}

#current problem data(*.in & *.out) backup
#c.f. : how to backup test files from HUSTOJ for CSL
#directory : /home/judge/
#command   : sudo zip -r data.zip ./data
sudo zip -r ./${BACKUPS}/data.zip /home/judge/data
#for restoring
echo "sudo rm -rf /home/judge/data" >> ./${BACKUPS}/${RESTOREFILE}
echo "sudo unzip ./data.zip -d /home/judge/" >> ./${BACKUPS}/${RESTOREFILE}

#HUSTOJ db_info.inc.php settings
sudo cp /home/judge/src/web/include/db_info.inc.php ./${BACKUPS}/include/
#for restoring
echo "sudo cp -f ./include/db_info.inc.php /home/judge/src/web/include/" >> ./${BACKUPS}/${RESTOREFILE}

#result time fix ... use_max_time
sudo cp /home/judge/etc/judge.conf ./${BACKUPS}/
#for restoring
echo "sudo cp -f ./judge.conf /home/judge/etc/" >> ./${BACKUPS}/${RESTOREFILE}

#Replacing msg.txt
sudo cp -f /home/judge/src/web/admin/msg.txt ./${BACKUPS}/admin/
#for restoring
echo "sudo cp -f ./admin/msg.txt /home/judge/src/web/admin/" >> ./${BACKUPS}/${RESTOREFILE}
echo "clear" >> ./${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> ./${BACKUPS}/${RESTOREFILE}
echo "echo \"HUSTOJ ${BACKUPS} successfully restored!\"" >> ./${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> ./${BACKUPS}/${RESTOREFILE}

clear

echo ""
echo "--- Current HUSTOJ successfully backuped at ${BACKUPS}! ---"
echo ""
echo "You can restore HUSTOJ ${BACKUPS} backups with below command ..."
echo "$ bash ~/${BACKUPS}/${RESTOREFILE}"
echo ""
echo "This Script is supported by CSL(South Korea CSTA)"
echo ""
