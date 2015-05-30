#! /bin/sh

# This script is executed during setting up of new VM instances

cd /tmp/

# Install anaconda
wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda-2.2.0-Linux-x86_64.sh
bash Anaconda-2.2.0-Linux-x86_64.sh -b -p /opt/anaconda

# Install git 2.4
yum install -y curl-devel expat-devel gettext-devel \
  openssl-devel zlib-devel
yum install -y asciidoc xmlto docbook2x
yum install -y gcc
wget https://github.com/git/git/archive/v2.4.1.tar.gz
tar xzf v2.4.1.tar.gz
cd git-2.4.1
make configure
./configure --prefix=/usr
make -j5 all doc
make install install-doc

# need readline5 for eos
yum install -y compat-readline5

# Install editors and stuff
yum install -y emacs
yum install -y xeyes
yum install -y xauth
yum install -y screen

# Jupyterhub
# /usr/local/bin is not in the PATH by default
# to start the hub you need to specify the full
# path: /usr/local/bin/jupyterhub when
# logging in as root
export PATH="/usr/local/bin:$PATH"
yum install -y npm
yum install -y sqlite-devel
wget https://www.python.org/ftp/python/3.4.3/Python-3.4.3.tgz
tar xzf Python-3.4.3.tgz
cd Python-3.4.3
./configure
make -j5
make altinstall
cd /tmp/
git clone https://github.com/jupyter/jupyterhub.git
cd jupyterhub
npm install -g configurable-http-proxy
pip3.4 install -r requirements.txt
pip3.4 install .
pip3.4 install "ipython[notebook]"
# installs the anaconda python2 kernel
ipython kernelspec install-self
cd /tmp/

# kerberos setup copied from lxplus
curl https://gist.githubusercontent.com/betatim/7c6795ebea7b9761f1a8/raw/b04c5af7a6810a9cc8f6f76129796d173acb4b84/krb5.conf > krb5.conf
cp /tmp/krb5.conf /etc/krb5.conf

# Install grid security stuff
curl http://thead.web.cern.ch/thead/grid-sec.tar.gz > grid-sec.tar.gz
tar xzf grid-sec.tar.gz
cp -a grid-security /etc/

# automate sourcing of LbLogin and setting up of anaconda path
curl https://gist.githubusercontent.com/betatim/476078b01443fa3a1885/raw/e90b6a7f12391a9d7e312a06d1cca23af39def84/gistfile1.txt > /etc/profile.d/zzz-starterkit.sh
curl https://gist.githubusercontent.com/betatim/e08dbf20b8ab77b4e22d/raw/3085e7444ee2fc0603e7a3c902bebe45714d3545/zzz-starterkit.csh > /etc/profile.d/zzz-starterkit.csh

# Install extra users
addusercern thead
addusercern kdungs
addusercern ibabusch
addusercern apearce
addusercern apuignav
addusercern raaij
addusercern sneubert
addusercern jadevrie
# Participants
addusercern rquaglia
addusercern amauri
addusercern svende
addusercern dgerick
addusercern flionett
addusercern mneuner
addusercern bmaurin
addusercern eprice
addusercern ismith
addusercern mstahl
addusercern bsiddi
addusercern admorris
addusercern mfiore
addusercern egraveri
addusercern maxime
addusercern vibattis
addusercern lupappal
addusercern dsaunder
addusercern mveghel
addusercern ldufour
addusercern anandi
addusercern ggazzoni
addusercern mussini
addusercern mfiorini
addusercern emichiel
addusercern apiucci
addusercern vibellee
addusercern lbel
addusercern nskidmor
addusercern segiani
addusercern mdemmer
addusercern tiwillia
addusercern kdreiman
addusercern vcogoni
addusercern lan
addusercern cvacca
addusercern dmitzel
addusercern mfiorin2

# Make sure the clock doens't drift
service ntpd start
