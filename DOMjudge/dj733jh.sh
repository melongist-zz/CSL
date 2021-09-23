#!/bin/bash

#origin
#https://www.domjudge.org/
#https://github.com/DOMjudge/domjudge

#DOMjudge server installation script
#DOMjudge7.3.3 stable + Ubuntu 20.04 LTS
#Made by melongist(melongist@gmail.com, what_is_computer@msn.com) for CS teachers

#terminal commands to install DOMjudge judgehosts
#------
#wget https://raw.githubusercontent.com/melongist/CSL/master/DOMjudge/dj733jh.sh
#bash dj733jh.sh


if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash dj733jh.sh'"
  exit 1
fi

cd

#change your timezone
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
#swift
sudo apt -y install clang libicu-dev
wget https://swift.org/builds/swift-5.4.2-release/ubuntu2004/swift-5.4.2-RELEASE/swift-5.4.2-RELEASE-ubuntu20.04.tar.gz
tar -zxvf swift-5.4.2-RELEASE-ubuntu20.04.tar.gz
rm swift-5.4.2-RELEASE-ubuntu20.04.tar.gz
sudo mv ~/swift-5.4.2-RELEASE-ubuntu20.04 ~/swift
sudo ln -s ~/swift/usr/bin/swiftc /usr/bin/swiftc


#DOMjudge 7.3.3 stable
cd domjudge-7.3.3
./configure --prefix=/opt/domjudge --with-baseurl=BASEURL


#make docs?
sudo apt -y install python3-sphinx python3-sphinx-rtd-theme rst2pdf fontconfig python3-yaml
make docs
sudo make install-docs

#make judgehost
make judgehost
sudo make install-judgehost

#default judgehost
#more judgehost... you can add more judgehosts by .... domjudge-run-X
sudo useradd -d /nonexistent -U -M -s /bin/false domjudge-run
sudo useradd -d /nonexistent -U -M -s /bin/false domjudge-run-0
sudo useradd -d /nonexistent -U -M -s /bin/false domjudge-run-1


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

#default(C,C++,Python,...)+R,swift
echo 'y' | sudo /opt/domjudge/judgehost/bin/dj_make_chroot -i r-base,swift


sudo apt -y autoremove

clear

cd
echo "" | tee -a domjudge.txt
echo "DOMjudge 7.3.3 stable 21.04.05" | tee -a domjudge.txt
echo "judgehosts installed!!" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "------ Run judgedamons after every reboot ------" | tee -a domjudge.txt
echo "sudo /opt/domjudge/judgehost/bin/create_cgroups" | tee -a domjudge.txt
#added for R    ... DOMJUDGE_CREATE_WRITABLE_TEMP_DIR=1
echo "sudo -u $USER DOMJUDGE_CREATE_WRITABLE_TEMP_DIR=1 setsid /opt/domjudge/judgehost/bin/judgedaemon &" | tee -a domjudge.txt
echo "sudo -u $USER DOMJUDGE_CREATE_WRITABLE_TEMP_DIR=1 setsid /opt/domjudge/judgehost/bin/judgedaemon -n 0 &" | tee -a domjudge.txt
echo "sudo -u $USER DOMJUDGE_CREATE_WRITABLE_TEMP_DIR=1 setsid /opt/domjudge/judgehost/bin/judgedaemon -n 1 &" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "------ etc ------" | tee -a domjudge.txt
echo "For swift! Check/Edit comple script below at Admin page" | tee -a domjudge.txt
echo "Admin page - Languages - swift - \"Compile script  swift\" - \"View file contents\" - Edit" | tee -a domjudge.txt
echo "..." | tee -a domjudge.txt
echo "swiftc -O -module-cache-path \"./\" -static-executable -static-stdlib -o \"\$DEST\" \$SOURCES\"" | tee -a domjudge.txt
echo "..." | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "How to kill some judgedaemon processe?" | tee -a domjudge.txt
echo "ps -ef, and find pid# of judgedaemon, run : kill -15 pid#" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "How to domserver http web cache reset?" | tee -a domjudge.txt
echo "sudo rm -rf /opt/domjudge/domserver/webapp/var/cache/prod/*" | tee -a domjudge.txt
echo "" | tee -a domjudge.txt
echo "Saved as domjudge.txt"
echo "reboot and read domjudge.txt"
