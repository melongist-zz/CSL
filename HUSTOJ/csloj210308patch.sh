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
sed -i "s/OJ_RUNNING=1/OJ_RUNNING=4/" /home/judge/etc/judge.conf
​
sed -i "s/OJ_PYTHON_FREE=0/OJ_PYTHON_FREE=1/" /home/judge/etc/judge.conf
​
#temporary until next HUSTOJ release
sed -i "s/318,17,41,42,72,99,217/318,17,41,42,49,72,99,217/" /home/judge/src/core/judge_client/okcalls64.h
sed -i "s/11,12,20,21,59,63,89,99,158,231,275,292,511/11,12,14,20,21,59,63,89,99,158,231,268,275,292,511/" /home/judge/src/core/judge_client/okcalls64.h

cd /home/judge/src/core/

bash make.sh

cd


clear

echo ""
echo "--- $OJNAME CSL HUSTOJ python error patched ---"
echo ""
echo "This Script is supported by CSL(South Korea CSTA)"
echo ""
echo "Rebooting..."

reboot