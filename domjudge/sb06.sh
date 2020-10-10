#!/bin/bash
#spotboard 0.6.0 for domjudge7.4.0.dev + Ubuntu 20.04 LTS Server

#terminal commands to install spotboard webapp
#wget https://raw.githubusercontent.com/melongist/CSL/master/domjudge/sb06.sh
#bash sb06.sh

#------
#spotboard for domjudge
cd

sudo apt update
sudo apt -y upgrade

sudo apt -y install nodejs
sudo apt -y install npm

#https://github.com/spotboard/spotboard
wget https://raw.githubusercontent.com/melongist/CSL/master/domjudge/spotboard-webapp-0.6.0.tar.gz
tar -xvf spotboard-webapp-0.6.0.tar.gz
mv spotboard-webapp-0.6.0 spotboard
sudo mv spotboard /var/www/html/

sed -i "s#feed_server_path = './sample/'#feed_server_path = './'#" /var/www/html/spotboard/config.js
sed -i "s#'award_slide.json' :'./sample/award_slide.json'#'award_slide.json' :'./award_slide.json'#" /var/www/html/spotboard/config.js
sed -i "s#animation          : false#animation          : true#" /var/www/html/spotboard/config.js

echo "" | tee -a domjudge.txt
echo "spotboard for domjudge installed!!" | tee -a domjudge.txt
echo "Ver 2020.10.09" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "Check spotboard!" | tee -a domjudge.txt
echo "------" | tee -a domjudge.txt
echo "http:/localhost/spotboard/" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "configuration for spotboard" | tee -a domjudge.txt
echo "check /var/www/html/spotboard/config.js" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "Next step : install spotboard-converter" | tee -a domjudge.txt
echo ""
echo ""


