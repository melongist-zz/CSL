#!/bin/bash
#CSL HUSTOJ
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teacher

VER_DATE="21.03.28"

THISFILE="cslojmaintenance.sh"

clear

echo ""
echo "---- CSL(Computer Science teachers's computer science Love) ----"
echo ""

if [[ -z $SUDO_USER ]] ; then
  echo "Use 'sudo bash ${THISFILE}'"
  exit 1
fi

cd

#for auto nginx log delete
find /var/log/nginx -mtime +1 -type f -ls -exec rm -r {} \;

#for maintenance
apt update
apt -y upgrade
reboot
