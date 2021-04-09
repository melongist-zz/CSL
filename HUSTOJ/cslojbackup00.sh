#!/bin/bash
#CSL HUSTOJ
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teachers

clear

VER_DATE="21.04.08"

THISFILE="cslojbackup00.sh"
RESTOREFILE="restore.sh"
USER="USERACCOUNT"





if [[ -z $SUDO_USER ]] ; then
  echo "Use 'sudo bash ${THISFILE}'"
  exit 1
fi

echo ""
echo "---- CSL HUSTOJ backup ----"
echo ""
echo "Waiting 3 seconds..."
echo ""


sleep 3


if [ ! -d /home/${USER}/cslojbackups ]; then
  mkdir /home/${USER}/cslojbackups
  chown ${USER}:${USER} /home/${USER}/cslojbackups  
fi


BACKUPS=$(echo `date '+%Y%m%d%H%M'`)
mkdir /home/${USER}/cslojbackups/${BACKUPS}

cp ./${THISFILE} /home/${USER}/cslojbackups/${BACKUPS}/
mv /home/${USER}/cslojbackups/${BACKUPS}/${THISFILE} /home/${USER}/cslojbackups/${BACKUPS}/${THISFILE}.bak 

touch /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "clear" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "if [[ -z \$USER ]] ; then" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "  echo \"Use 'sudo bash ${RESTOREFILE}'\"" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "  exit 1" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "fi" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"---- CSL HUSTOJ backup restore ----\"" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "INPUTS=\"n\"" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "echo -n \"This script will restore ${BACKUPS} backup. Are you sure?[y/n] \"" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "read INPUTS" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "if [ \${INPUTS} = \"n\" ]; then" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "  exit 1" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "fi" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}


DBUSER=$(grep user /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
PASSWORD=$(grep password /etc/mysql/debian.cnf|head -1|awk  '{print $3}')

#current mysql backup
#how to backup database : mysqldump -u debian-sys-maint -p jol > jol.sql
mysqldump -u ${DBUSER} -p$PASSWORD jol > /home/${USER}/cslojbackups/${BACKUPS}/jol.sql
#for restoring
echo "DBUSER=\$(grep user /etc/mysql/debian.cnf|head -1|awk  '{print \$3}')" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "PASSWORD=\$(grep password /etc/mysql/debian.cnf|head -1|awk  '{print \$3}')" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "mysql -u \${DBUSER} -p\${PASSWORD} jol < jol.sql" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}

#current /home/judge/ directory backup
#how to backup /home/judge/ directory : sudo tar -zcvf ~/cslojjudge.tar.gz /home/judge/
sed -i "s/$DB_PASS=\"${PASSWORD}\"/$DB_PASS=\"HUSTOJPASSWORD\"/" /home/judge/src/web/include/db_info.inc.php
tar -zcvf /home/${USER}/cslojbackups/${BACKUPS}/cslojjudge.tar.gz /home/judge
sed -i "s/$DB_PASS=\"HUSTOJPASSWORD\"/$DB_PASS=\"${PASSWORD}\"/" /home/judge/src/web/include/db_info.inc.php
#for restoring
echo "rm -rf /home/judge/" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "tar -zxvf ./cslojjudge.tar.gz -C /" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "sed -i \"s/\$DB_PASS=\\\"HUSTOJPASSWORD\\\"/\$DB_PASS=\\\"\${PASSWORD}\\\"/\" /home/judge/src/web/include/db_info.inc.php" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"--- CSL HUSTOJ backup ${BACKUPS} restored!! ---\"" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}
echo "echo \"\"" >> /home/${USER}/cslojbackups/${BACKUPS}/${RESTOREFILE}

echo ""
echo "---- CSL HUSTOJ backuped successfully at ${BACKUPS} ----"
echo ""
echo "You can restore CSL HUSTOJ ${BACKUPS} backup with ..."
echo ""
echo "$ sudo bash ~/cslojbackups/${BACKUPS}/${RESTOREFILE}"
echo ""
