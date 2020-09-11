#kindeditor korean setting
#cd /home/judge/src/web/admin/
#sudo rm kindeditor.php
#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/kindeditor.php
#sudo chown www-data kindeditor.php

#front, rear, bann setting
#cd /home/judge/src/web/
#sudo rm submit.php
#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/submit.php
#sudo chown www-data submit.php

#QR codes removing + CSL link
#cd /home/judge/src/web/template/bs3/
#sudo rm js.php
#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/js.php
#sudo chown www-data js.php

#copy all images to server
#cd /home/judge/src/web/upload
#sudo rm -rf *
#wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/csl100v00.tar.gz
#sudo tar zxvf csl100v00.tar.gz
#sudo rm csl100v00.tar.gz

#install phpmyadmin
#sudo apt install phpmyadmin
#sudo ln -f -s /usr/share/phpmyadmin /home/judge/src/web/phpmyadmin
#sudo mv /home/judge/src/web/phpmyadmin /home/judge/src/web/pma

#clear
#echo "HUSTOJ ver CSL100v00 completed!!"

#sql overwriting
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/csl100v00jol.sql

USER=$(grep user /etc/mysql/debian.cnf|head -1|awk  '{print $3}')
PASSWORD=$(grep password /etc/mysql/debian.cnf|head -1|awk  '{print $3}')

#echo "Remember your database account for HUST Online Judge:"
#echo "username:$USER"
#echo "password:$PASSWORD"

mysql -h localhost -u $USER -p$PASSWORD jol < csl100v00jol.sql
quit


echo "CSL basic 100 problems install completed!!"





