#!/bin/bash
#CSL HUSTOJ
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teachers

clear


VER_DATE="21.04.09"

THISFILE="cslojmaintenance00.sh"




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



#---- You can edit below processes ----

#deleting nginx log
find /var/log/nginx -mtime +1 -type f -ls -exec rm -r {} \;

#deleting old backups
find /home/${SUDO_USER}/cslojbackups -mtime +10 -type d -ls -exec rmdir -rf {} \;

#auto backup
bash /home/${SUDO_USER}/cslojbackup00.sh -auto


#for maintenance
apt update
apt -y upgrade

echo "---- system reboot ----"
echo ""
echo "Waiting 3 seconds..."


sleep 3

reboot
