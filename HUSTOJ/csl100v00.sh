cd /home/judge/src/web/admin/
sudo rm kindeditor.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/kindeditor.php
sudo chown www-data kindeditor.php

cd /home/judge/src/web/
sudo rm submit.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/submit.php
sudo chown www-data submit.php

cd /home/judge/src/web/template/bs3/
sudo rm js.php
wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/js.php
sudo chown www-data js.php

echo "CSL100v00 ready"

