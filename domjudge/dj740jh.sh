#!/bin/bash
#for domjudge7.4.0.dev + AWS Ubuntu 20.04 LTS Server

#judgehost 만들기

sudo apt -y install debootstrap
sudo apt -y install default-jre-headless
sudo apt -y install default-jdk-headless
sudo apt -y install ghc
sudo apt -y install fp-compiler

#cd domjudge-7.3.0
cd domjudge-7.4.0.dev
./configure --prefix=/opt/domjudge --with-baseurl=BASEURL

#make docs?
make docs
sudo make install-docs

make judgehost
sudo make install-judgehost

sudo useradd -d /nonexistent -U -M -s /bin/false domjudge-run

#PC 설치 버전에서는 아래 방법만으로 되지만, AWS에서는 안됨 추가로 더 작업을 해야함.
sudo sed -i "s#GRUB_CMDLINE_LINUX_DEFAULT=\"\"#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet cgroup_enable=memory swapaccount=1\"#" /etc/default/grub

#AWS 용 처리
sudo sed -i "s#GRUB_CMDLINE_LINUX_DEFAULT=\"console=tty1 console=ttyS0 nvme_core.io_timeout=4294967295\"#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet cgroup_enable=memory swapaccount=1\"#" /etc/default/grub.d/50-cloudimg-settings.cfg

sudo update-grub
echo "after : sudo reboot"
echo "run   : sudo /opt/domjudge/judgehost/bin/dj_make_chroot"
echo "run   : sudo /opt/domjudge/judgehost/bin/judgedaemon"

#sudo reboot

#재부팅하고 나서 아래 명령어를 실행하면 저지호스트가 실행됨

#cd /opt/domjudge/judgehost/bin/
#sudo ./dj_make_chroot
#sudo ./dj_make_chroot -D Ubuntu -R bionic #이건 7.3.0 버전에서 dj_make_chroot 실행 안 될때...
#./judgedaemon