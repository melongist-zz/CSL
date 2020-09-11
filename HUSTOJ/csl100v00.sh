sudo apt update
sudo apt upgrade

#kindeditor korean setting
cd /home/judge/src/web/admin/
sudo rm kindeditor.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/kindeditor.php
sudo chown www-data kindeditor.php

#front, rear, bann setting
cd /home/judge/src/web/
sudo rm submit.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/submit.php
sudo chown www-data submit.php

#QR codes removing + CSL link
cd /home/judge/src/web/template/bs3/
sudo rm js.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/js.php
sudo chown www-data js.php

#copy all images to server
cd /home/judge/src/web/upload
sudo rm -rf *
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/csl100v00image.tar.gz
sudo tar zxvf csl100v00image.tar.gz
sudo rm csl100v00.tar.gz

#copy all data to server
cd /home/judge/
sudo rm -rf data
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/csl100v00data.tar.gz
sudo tar zxvf csl100v00data.tar.gz
sudo rm csl100v00data.tar.gz

#install phpmyadmin
cd
sudo apt install phpmyadmin
sudo ln -f -s /usr/share/phpmyadmin /home/judge/src/web/phpmyadmin
sudo mv /home/judge/src/web/phpmyadmin /home/judge/src/web/pma

#sql overwriting
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/csl100v00jol.sql

USER=$(grep user /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
PASSWORD=$(grep password /etc/mysql/debian.cnf|head -1|awk  '{print $3}')

#echo "Remember your database account for HUST Online Judge:"
#echo "username:$USER"
#echo "password:$PASSWORD"

mysqladmin -u $USER -p$PASSWORD create jol
mysql -u $USER -p$PASSWORD jol < csl100v00jol.sql
sudo rm csl100v00jol.sql

clear
echo "Ver 2020.09.11"
echo "CSL basic 100 problems install completed!!"
echo "HUSTOJ admin ID : admin"
echo "HUSTOJ admin PW : computerscience"
echo ""
echo "Log in as admin and change new PW for admin!"
