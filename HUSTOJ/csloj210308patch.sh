#!/bin/bash
#CSL HUSTOJ
#Made by melongist(what_is_computer@msn.com)
#for CSL Computer Science teacher

VER_DATE="21.03.23"

THISFILE="csloj210308patch.sh"

clear

echo ""
echo "---- CSL(Computer Science teachers's computer science Love) ----"
echo ""

if [[ -z $SUDO_USER ]] ; then
  echo "Use 'sudo bash ${THISFILE}'"
  exit 1
fi


apt update
​
apt -y upgrade
​
#small fix for status.php
sed -i "s#KB</div># KB</div>#" /home/judge/src/web/status.php
sed -i "s#ms</div># ms</div>#" /home/judge/src/web/status.php

#for python judging error patch
sed -i "s/OJ_RUNNING=1/OJ_RUNNING=4/" /home/judge/etc/judge.conf
sed -i "s/OJ_PYTHON_FREE=0/OJ_PYTHON_FREE=1/" /home/judge/etc/judge.conf
​
#for contest problem view fix
sed -i "s#\`end_time\`>'\$now' or \`private\`='1'#\`start_time\`<'\$now' AND \`end_time\`>'\$now'#" /home/judge/src/web/problem.php
​
#for cslojmaintenance
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/cslojmaintenance.sh -O /home/${SUDO_USER}/cslojmaintenance.sh
chown ${SUDO_USER}:${SUDO_USER} /home/${SUDO_USER}/cslojmaintenance.sh

if [ -e "/var/spool/cron/crontabs/root" ]; then
  if grep "cslojmaintenance.sh" /var/spool/cron/crontabs/root ; then
    sed -i '/cslojmaintenance.sh/d' /var/spool/cron/crontabs/root
  fi
fi

crontab -l > temp
echo '30 4 * * * sudo bash /home/'${SUDO_USER}'/cslojmaintenance.sh' >> temp
crontab temp
rm -f temp



#temporary until next HUSTOJ release
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/web/lang/ko.php
mv -f ./ko.php /home/judge/src/web/lang/ko.php
chown www-data:root /home/judge/src/web/lang/ko.php
chmod 644 /home/judge/src/web/lang/ko.php

sed -i "s/318,17,41,42,72,99,217/318,17,41,42,49,72,99,217/" /home/judge/src/core/judge_client/okcalls64.h
sed -i "s/99,158,231,275,292,511/99,158,186,231,234,268,275,292,511/" /home/judge/src/core/judge_client/okcalls64.h
sed -i "s/11,12,20,21,59,63,89,99/11,12,14,20,21,39,59,63,89,99/" /home/judge/src/core/judge_client/okcalls64.h
cd /home/judge/src/core/
bash make.sh



clear

echo ""
echo "--- $OJNAME CSL HUSTOJ python error patched ---"
echo ""
echo "This Script is supported by CSL(South Korea CSTA)"
echo ""
echo "Rebooting..."

reboot