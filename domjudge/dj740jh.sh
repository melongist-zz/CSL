#!/bin/bash
#domjudge7.4.0.dev + Ubuntu 20.04 LTS Server

#judgehost

sudo apt -y install debootstrap
sudo apt -y install default-jre-headless
sudo apt -y install default-jdk-headless
sudo apt -y install ghc
sudo apt -y install fp-compiler

#cd domjudge-7.3.0
cd domjudge-7.4.0.dev
./configure --prefix=/opt/domjudge --with-baseurl=BASEURL

#make docs
make docs
sudo make install-docs

#make judgehost
make judgehost
sudo make install-judgehost

#default judgehost
sudo useradd -d /nonexistent -U -M -s /bin/false domjudge-run

#more judgehost... you can add more judgehosts by .... domjudge-run-X
sudo useradd -d /nonexistent -U -M -s /bin/false domjudge-run-0
sudo useradd -d /nonexistent -U -M -s /bin/false domjudge-run-1
#sudo useradd -d /nonexistent -U -M -s /bin/false domjudge-run-2
#sudo useradd -d /nonexistent -U -M -s /bin/false domjudge-run-3
#sudo useradd -d /nonexistent -U -M -s /bin/false domjudge-run-4
#sudo useradd -d /nonexistent -U -M -s /bin/false domjudge-run-5


sudo cp /opt/domjudge/judgehost/etc/sudoers-domjudge /etc/sudoers.d/
sudo chmod 0440 /etc/sudoers.d/sudoers-domjudge


sudo sed -i "s#GRUB_CMDLINE_LINUX_DEFAULT=\"\"#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet cgroup_enable=memory swapaccount=1\"#" /etc/default/grub

#for AWS Ubuntu 20.04 LTS Server
if [ -f /etc/default/grub.d/50-cloudimg-settings.cfg ]; then
	echo "Editing /etc/default/grub.d/50-cloudimg-settings.cfg for AWS"
  sudo sed -i "s#GRUB_CMDLINE_LINUX_DEFAULT=\"console=tty1 console=ttyS0 nvme_core.io_timeout=4294967295\"#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet cgroup_enable=memory swapaccount=1\"#" /etc/default/grub.d/50-cloudimg-settings.cfg
fi

sudo update-grub

sudo /opt/domjudge/judgehost/dj_make_chroot

echo ""
echo "---- judgehost installed ----"
echo "run : sudo reboot"
echo ""
echo "---- Every after reboot ----"
echo "run : sudo /opt/domjudge/judgehost/bin/create_cgroups"
echo "run : setsid nohup /opt/domjudge/judgehost/bin/judgedaemon &"
echo "run : setsid nohup /opt/domjudge/judgehost/bin/judgedaemon -n 0 &"
echo "run : setsid nohup /opt/domjudge/judgehost/bin/judgedaemon -n 1 &"
#echo "run : setsid nohup /opt/domjudge/judgehost/bin/judgedaemon -n 2 &"
#echo "run : setsid nohup /opt/domjudge/judgehost/bin/judgedaemon -n 3 &"
#echo "run : setsid nohup /opt/domjudge/judgehost/bin/judgedaemon -n 4 &"
#echo "run : setsid nohup /opt/domjudge/judgehost/bin/judgedaemon -n 5 &"

echo "If you want to kill judgedaemon processes?"
echo "run : ps -ef, and check pid# of judgedaemons, run : kill -15 pid#"

