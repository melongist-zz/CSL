#20.10.19   

---
#DOMjudge 7.4.0.DEV installation   
<https://www.domjudge.org/>   

#Prerequisite
- Ubuntu 20.04 LTS Server/Desktop installed (AWS OK)   

#Installation commands
<pre><code>
wget https://raw.githubusercontent.com/melongist/CSL/master/domjudge/dj740dj.sh
bash dj740dj.sh
</code></pre>

#While installing...   
<pre><code>
...   
Enter current password for root (enter for none) :    // <- enter   
...   
Switch to unix_socket autentication [Y/n] :           // <- n   
...   
Change the root password? [Y/n] :                     // <- y      //you must change mariadb's root password! #1   
...   
Remove anonymous user? [Y/n] :                        // <- y   
...   
Disallow root login remotely? [Y/n] :                 // <- y   
...   
Remove test database and access to it? [Y/n] :        // <- y   
...   
Reload privilege tables now? [Y/n] :                  // <- y   
...
...   
...   
Database credentials read from '/opt/domjudge/domserver/etc/dbpasswords.secret'.   
Enter password:                                       // <- input upper              mariadb's root password! #1   
DOMjudge database and user(s) created.   
Enter password:                                       // <- input upper              mariadb's root password! #1   
...   
</code></pre>

#After DOMserver installed.
<pre><code>
Check below to access DOMserver's web interface!    
------    
admin ID : admin    
admin PW : ????????????????    
    
admin PW saved as domjudge.txt    
Next step : install judgehosts    
    
</code></pre>

---
#DOMjudge judgehosts installation   
<https://www.domjudge.org/>   

#Prerequisite
- DOMjudge(server) installed   

#Installation commands to install judgehosts at the same DOMserver   
#with default 1 judgehost + 2 more judgehosts
<pre><code>
wget https://raw.githubusercontent.com/melongist/CSL/master/domjudge/dj740jh.sh
bash dj740jh.sh
</code></pre>

#After judgehosts installed.
<pre><code>
run : sudo reboot

------ After every reboot ------
run : sudo /opt/domjudge/judgehost/bin/create_cgroups   
run : setsid /opt/domjudge/judgehost/bin/judgedaemon &   
run : setsid /opt/domjudge/judgehost/bin/judgedaemon -n 0 &   
run : setsid /opt/domjudge/judgehost/bin/judgedaemon -n 1 &   

If you want to kill some judgedaemon processe?   
ps -ef, and find pid# of judgedaemon, run : kill -15 pid#   

Saved as domjudge.txt
</code></pre>


---
#spotboard for domjudge   
<https://github.com/spotboard/spotboard>

#Prerequisite   
- DOMjudge(server + judgehost) installed   

#Installation commands to install spotboard for domjudge   

<pre><code>
wget https://raw.githubusercontent.com/melongist/CSL/master/domjudge/sb070.sh
bash sb070.sh
</code></pre>

#After judgehosts installed.
<pre><code>
Check spotboard!
------
http://localhost/spotboard/dist/

configuration for spotboard
check & edit /var/www/html/spotboard/dist/config.js

Next step : install spotboard-converter

</code></pre>


---
#spotboard-converter for spotboard   
<https://github.com/spotboard/domjudge-converter>

#Prerequisite   
- DOMjudge(server + judgehost) installed server   
- spotboard installed    
- spotboard account with 'Jury User' Roles : added with DOMjudge web interface   
    ex)   
    ID: spotboard   
    PW: spotboard   
    Roles: Jury User    

#Installation commands to install spotboard-converter for domjudge   

<pre><code>
wget https://raw.githubusercontent.com/melongist/CSL/master/domjudge/sbc070.sh
bash sbc070.sh
</code></pre>

#After spotboard-converter installed.
<pre><code>
domjudge-converter for domjudge installed!!
Ver 2020.10.19

------ run npm start every reboot ------
run : cd dcm
run : setsid npm start &
Check spotboard!

------
http:/localhost/spotboard/dist/

configuration for domjudge-converter
check and edit ~/dcm/config.js
</code></pre>

