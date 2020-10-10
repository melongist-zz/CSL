#20.10.06   
#Installation script for DOMjudge 7.4.0.DEV
   
---
#Terminal commands. To install DOMserver
<pre><code>
wget https://raw.githubusercontent.com/melongist/CSL/master/domjudge/dj740dj.sh
bash dj740dj.sh
</code></pre>

#While installing...   
<pre><code>
...   
Enter current password for root (enter for none) : // <- enter   
...   
Switch to unix_socket autentication [Y/n] : // <- n   
...   
Change the root password? [Y/n] : // <- y //you must change mariadb's root acount password! #1   
...   
Remove anonymous user? [Y/n] : // <- y   
...   
Disallow root login remotely? [Y/n] : // <- y   
...   
Remove test database and access to it? [Y/n] : // <- y   
...   
Reload privilege tables now? [Y/n] : // <- y   
...
...   
...   
Database credentials read from '/opt/domjudge/domserver/etc/dbpasswords.secret'.   
Enter password: // <- enter upper #1 password   
DOMjudge database and user(s) created.   
Enter password: // <- enter upper #1 password   
...   
</code></pre>

#After DOMserver installed!
<pre><code>
domjudge 7.4.0.DEV DOMserver installed!!    
Ver 2020.10.09    

Check below to access DOMserver's web interface!    
------    
admin ID : admin    
admin PW : ????????????????    
    
admin PW saved as domjudge.txt    
Next step : install judgehosts    
    
</code></pre>

---
#Terminal commands. To install judgehosts at the same DOMserver   
#with default 1 judgehost + 2 more judgehosts
<pre><code>
wget https://raw.githubusercontent.com/melongist/CSL/master/domjudge/dj740jh.sh
bash dj740jh.sh
</code></pre>

#After judgehosts installed!
<pre><code>
domjudge 7.4.0.DEV judgedaemons installed!!
Ver 2020.10.09

Check below to access DOMserver's web interface!
------
admin ID : admin
admin PW : ????????????????

domjudge 7.4.0.DEV judgehosts installed!!
Ver 2020.10.09

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
