#!/bin/bash
#CSL HUSTOJ
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teachers

clear


VER_DATE="21.04.09"

THISFILE="cslojmaintenance00.sh"
USER="USERACCOUNT"




if [[ -z $SUDO_USER ]] ; then
  echo "Use 'sudo bash ${THISFILE}'"
  exit 1
fi

echo ""
echo "---- CSL HUSTOJ maintenance ----"
echo ""
echo "Waiting 3 seconds..."
echo ""


sleep 3


#deleting nginx log
find /var/log/nginx -mtime +1 -type f -ls -exec rm -r {} \;

#deleting old backups
find /home/${USER}/cslojbackups -mtime +10 -type f -ls -exec rm -rf {} \;

#auto backup
bash /home/${USER}/cslojbackup00.sh


#for maintenance
apt update
apt -y upgrade

echo "---- system reboot ----"

sleep 3

reboot
