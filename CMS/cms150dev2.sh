#!/bin/bash

#http://cms-dev.github.io/
#https://github.com/cms-dev/cms

#CMS1.5.0.dev + Ubuntu 20.04 LTS Server
#Installation

#------

cd

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash cms150dev2.sh'"
  exit 1
fi

cd cms

sudo pip3 install -r requirements.txt

wget https://raw.githubusercontent.com/melongist/CSL/master/CMS/db.txt

USERPW="o"
INPUTS="x"
while [ ${USERPW} != ${INPUTS} ]; do
  echo -n "Enter  postgresql cmsuser password : "
  read USERPW
  echo -n "Repeat postgresql cmsuser password : "
  read INPUTS
done

sudo sed -i "s#login password 'enternewpassword'#login password '$USERPW'#" ./db.txt
sudo su - postgres < db.txt
cd

sudo sed -i "s#your_password_here#$USERPW#" /usr/local/etc/cms.conf
sudo chown cmsuser:cmsuser /usr/local/etc/cms.conf

cd cms
sudo python3 setup.py install
cd

cmsInitDB

cmsAddAdmin admin -p $USERPW

setsid cmsAdminWebServer &
setsid cmsResourceService -a &

echo "cms1.5.0dev installation completed!!" | tee -a cms.txt
echo "Ver 2020.11.26 CSL" | tee -a cms.txt
echo "" | tee -a cms.txt
echo "------ After every reboot ------" | tee -a cms.txt
echo "For CMS admin page" | tee -a cms.txt
echo "run : cmsAdminWebServer" | tee -a cms.txt
echo "      id : admin" | tee -a cms.txt
echo "      pw : $USERPW" | tee -a cms.txt
echo ""
echo "For service monitoring" | tee -a cms.txt
echo "run : cmsResourceService -a" | tee -a cms.txt
