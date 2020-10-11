#!/bin/bash
#domjudge korean interface for beginner

#terminal commands to install domjudge korean interface
#wget https://raw.githubusercontent.com/melongist/CSL/master/domjudge/kor/domkor.sh
#bash domkor.sh

#------
#domjudge korean interface for beginner
cd
sudo rm -rf /opt/domjuge/domserver/webapp/templastes
wget https://raw.githubusercontent.com/melongist/CSL/master/domjudge/kor/templates.tar.gz
sudo tar -zxvf templates.tar.gz
sudo mv templates /opt/domjudge/domserver/webapp/templates/
sudo rm -rf /opt/domjudge/domserver/webapp/var/cache/prod/*

echo ""
echo "domjudge korean interface for beginner installed!!"
echo ""
echo "Check domjudge!"
echo ""
