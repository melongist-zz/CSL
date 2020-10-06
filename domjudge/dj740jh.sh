#!/bin/bash
#for domjudge7.4.0.dev + Ubuntu 20.04 LTS Server

#judgehost 만들기
#기본 judgehost 3개 버전... 

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
sudo useradd -d /nonexistent -U -M -s /bin/false domjudge-run-0
sudo useradd -d /nonexistent -U -M -s /bin/false domjudge-run-1

sudo cp /opt/domjudge/judgehost/etc/sudoers-domjudge /etc/sudoers.d/
sudo chmod 0440 /etc/sudoers.d/sudoers-domjudge



sudo sed -i "s#GRUB_CMDLINE_LINUX_DEFAULT=\"\"#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet cgroup_enable=memory swapaccount=1\"#" /etc/default/grub

#AWS 용 처리
if [ -f /etc/default/grub.d/50-cloudimg-settings.cfg ]; then
	echo "Editing /etc/default/grub.d/50-cloudimg-settings.cfg for AWS"
  sudo sed -i "s#GRUB_CMDLINE_LINUX_DEFAULT=\"console=tty1 console=ttyS0 nvme_core.io_timeout=4294967295\"#GRUB_CMDLINE_LINUX_DEFAULT=\"quiet cgroup_enable=memory swapaccount=1\"#" /etc/default/grub.d/50-cloudimg-settings.cfg
fi

sudo update-grub

sudo /opt/domjudge/judgehost/dj_make_chroot

echo ""
echo "---- judgehost install ready ----"
echo "run : sudo reboot"
echo ""
echo "---- after reboot ----"
echo "run : sudo /opt/domjudge/judgehost/bin/create_cgroups"
echo "run : setsid nohup /opt/domjudge/judgehost/bin/judgedaemon &"
echo "run : setsid nohup /opt/domjudge/judgehost/bin/judgedaemon -n 0 &"
echo "run : setsid nohup /opt/domjudge/judgehost/bin/judgedaemon -n 1 &"
echo "if you want to kill judgedaemon process. ps -ef, check pid#, kill -15 pid#"

#재부팅하고 나서 아래 명령어를 실행하면 저지호스트가 실행됨
#sudo /opt/domjudge/judgehost/bin/dj_make_chroot    <- 이거는 한 번만 실행시키면 됨.
#7.3.0 버전에서 dj_make_chroot 실행 안 될 때에는 ... sudo ./dj_make_chroot -D Ubuntu -R bionic
#     /opt/domjudge/judgehost/bint/judgedaemon  를 실행시키면 저지데몬이 실행되면서 채점함.
#setsid nohup /opt/domjudge/judgehost/bin/judgedaemon &   명령어를 EC2 터미널에서 실행시킨 후 종료 시키면 됨.


