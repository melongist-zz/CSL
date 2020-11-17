#!/bin/bash

#http://cms-dev.github.io/
#https://github.com/cms-dev/cms


#CMS1.5.0.dev + Ubuntu 20.04 LTS Server

#terminal commands to install
#------
#wget https://raw.githubusercontent.com/melongist/CSL/master/CMS/cms150.sh
#bash cms150.sh

#------
#CMS

if [[ $SUDO_USER ]] ; then
  echo "Just use 'bash cms150.sh'"
  exit 1
fi

cd

#for South Korea's timezone
sudo timedatectl set-timezone 'Asia/Seoul'

sudo apt update
sudo apt -y upgrade
sudo apt autoremove

sudo apt -y install build-essential
sudo apt -y install openjdk-11-jdk-headless
sudo apt -y install fp-compiler
sudo apt -y install postgresql
sudo apt -y install postgresql-contrib
sudo apt -y install postgresql-client
sudo apt -y install python3.9
sudo apt -y install cppreference-doc-en-html
sudo apt -y install cgroup-lite
sudo apt -y install libcap-dev
sudo apt -y install zip

sudo apt -y install nginx-full
sudo apt -y install python2.7
sudo apt -y install php7.4-cli
sudo apt -y install php7.4-fpm
sudo apt -y install phppgadmin
sudo apt -y install texlive-latex-base
sudo apt -y install a2ps
sudo apt -y install haskell-platform
sudo apt -y install rustc
sudo apt -y install mono-mcs

sudo apt -y install fp-units-base
sudo apt -y install fp-units-fcl
sudo apt -y install fp-units-misc
sudo apt -y install fp-units-math
sudo apt -y install fp-units-rtl

sudo apt -y install python3-setuptools
sudo apt -y install python3-tornado
sudo apt -y install python3-psycopg2
sudo apt -y install python3-sqlalchemy
sudo apt -y install python3-psutil
sudo apt -y install python3-netifaces
sudo apt -y install python3-pycryptodome
sudo apt -y install python3-crypto
sudo apt -y install python3-six
sudo apt -y install python3-bs4
sudo apt -y install python3-coverage
sudo apt -y install python3-mock
sudo apt -y install python3-requests
sudo apt -y install python3-werkzeug
sudo apt -y install python3-gevent
sudo apt -y install python3-bcrypt
sudo apt -y install python3-chardet
sudo apt -y install patool
sudo apt -y install python3-babel
sudo apt -y install python3-xdg
sudo apt -y install python3-future
sudo apt -y install python3-jinja2

sudo apt -y install python3-yaml
sudo apt -y install python3-sphinx
sudo apt -y install python3-cups
sudo apt -y install python3-pypdf2

wget https://raw.githubusercontent.com/melongist/CSL/master/CMS/cms-master-20201117.tar

tar xvf cms-master-20201117.tar

mv cms-master-20201117 cms

cd cms

sudo python3 prerequisites.py install

sudo reboot




cd cms

sudo python3 setup.py install


