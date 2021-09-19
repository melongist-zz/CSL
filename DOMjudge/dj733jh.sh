#!/bin/bash

#by CSL
#DOMjudge judgehosts installation script
#Made by melongist(what_is_computer@msn.com)
#for Korean


#https://www.domjudge.org/
#https://github.com/DOMjudge/domjudge

#domjudge7.3.3 stable + Ubuntu 20.04 LTS Server

#terminal commands to install judgehosts
#------
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj733jh.sh
#bash dj733jh.sh

#------
#judgehosts

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj733jh.sh'"
  exit 1
fi

cd

#for South Korea's timezone
sudo timedatectl set-timezone 'Asia/Seoul'

sudo apt update
sudo apt -y upgrade

sudo apt -y install debootstrap

#java
sudo apt -y install default-jre-headless
sudo apt -y install default-jdk-headless
#haskell
sudo apt -y install ghc
#pascal
sudo apt -y install fp-compiler

#R
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
sudo apt -y install r-base
DOMJUDGE_CREATE_WRITABLE_TEMP_DIR=1

#swiftc
sudo apt -y install clang libicu-dev
wget https://swift.org/builds/swift-5.4.2-release/ubuntu2004/swift-5.4.2-RELEASE/swift-5.4.2-RELEASE-ubuntu20.04.tar.gz
tar -zxvf swift-5.4.2-RELEASE-ubuntu20.04.tar.gz
sudo ln -s ~/swift-5.4.2-RELEASE-ubuntu20.04/usr/bin/swiftc /usr/bin/swiftc


cd domjudge-7.3.3
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
#sudo useradd -d /nonexistent -U -M -s /bin/false domjudge-run-6

sudo cp /opt/domjudge/judgehost/etc/sudoers-domjudge /etc/sudoers.d/
sudo chmod 0440 /etc/sudoers.d/sudoers-domjudge

#try #1 for Ubuntu Desktop
sudo sed -i "s#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet cgroup_enable=memory swapaccount=1\"#" /etc/default/grub
#try #2 for Ubuntu Server
sudo sed -i "s#GRUB_CMDLINE_LINUX_DEFAULT=\"\"#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet cgroup_enable=memory swapaccount=1\"#" /etc/default/grub
#try #3 AWS Ubuntu 20.04 LTS Server
if [ -f /etc/default/grub.d/50-cloudimg-settings.cfg ]; then
	echo "Editing /etc/default/grub.d/50-cloudimg-settings.cfg for AWS"
  sudo sed -i "s#GRUB_CMDLINE_LINUX_DEFAULT=\"console=tty1 console=ttyS0 nvme_core.io_timeout=4294967295\"#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet cgroup_enable=memory swapaccount=1\"#" /etc/default/grub.d/50-cloudimg-settings.cfg
fi

sudo update-grub


#default
#sudo /opt/domjudge/judgehost/bin/dj_make_chroot
#default(C,C++,Python2,...) + R,swift
echo 'y' | sudo /opt/domjudge/judgehost/bin/dj_make_chroot -i r-base,swift


clear

cd
echo "" | tee -a domjudge.txt
echo "judgehosts installed!!" | tee -a domjudge.txt
echo "DOMjudge 7.3.3 stable 21.04.05" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "Next step : reboot, create_cgroups and run judgedaemons"
echo "run : sudo reboot" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "------ After every reboot ------" | tee -a domjudge.txt
echo "run : sudo /opt/domjudge/judgehost/bin/create_cgroups" | tee -a domjudge.txt
echo "run : setsid /opt/domjudge/judgehost/bin/judgedaemon &" | tee -a domjudge.txt
echo "run : setsid /opt/domjudge/judgehost/bin/judgedaemon -n 0 &" | tee -a domjudge.txt
echo "run : setsid /opt/domjudge/judgehost/bin/judgedaemon -n 1 &" | tee -a domjudge.txt
#echo "run : setsid /opt/domjudge/judgehost/bin/judgedaemon -n 2 &" | tee -a domjudge.txt
#echo "run : setsid /opt/domjudge/judgehost/bin/judgedaemon -n 3 &" | tee -a domjudge.txt
#echo "run : setsid /opt/domjudge/judgehost/bin/judgedaemon -n 4 &" | tee -a domjudge.txt
#echo "run : setsid /opt/domjudge/judgehost/bin/judgedaemon -n 5 &" | tee -a domjudge.txt
#echo "run : setsid /opt/domjudge/judgehost/bin/judgedaemon -n 6 &" | tee -a domjudge.txt

echo "" | tee -a domjudge.txt
echo "If you want to kill some judgedaemon processe?" | tee -a domjudge.txt
echo "ps -ef, and find pid# of judgedaemon, run : kill -15 pid#" | tee -a domjudge.txt
echo ""
echo "Saved as domjudge.txt"
echo ""
echo ""
