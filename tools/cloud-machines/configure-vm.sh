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
make all doc
make install install-doc

# kerberos setup copied from lxplus
curl https://gist.githubusercontent.com/betatim/7c6795ebea7b9761f1a8/raw/b04c5af7a6810a9cc8f6f76129796d173acb4b84/krb5.conf > krb5.conf
cp /tmp/krb5.conf /etc/krb5.conf

# automate sourcing of LbLogin and setting up of anaconda path
curl https://gist.githubusercontent.com/betatim/476078b01443fa3a1885/raw/e90b6a7f12391a9d7e312a06d1cca23af39def84/gistfile1.txt > /etc/profile.d/zzz-starterkit.sh

# Install extra users
addusercern thead
yum install -y cern-config-users
/usr/sbin/cern-config-users --setup-all
