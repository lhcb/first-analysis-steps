---
layout: page
title: Setting up a VM for LHCb
subtitle: Setting up a CERN openstack VM for LHCb work mainly using CVMFS
minutes: 30+
---

TODO:
* Show some simple benchmarks if this is better/worse for certain tasks than lxplus
* Work out what the AFS login script does and if it can be made to ignore AFS when present by default.

### What

This is a guide to setup a VM on the CERN openstack cluster to do LHCb work.

This has the advantage of being a VM which has some 'dedicated' resources which won't get impacted by multiple users logging into the VM and building many different projects.

This also allows you to work entirely without AFS using resources provided by CERN.
You can ignore the steps here to remove/avoid AFS but I'd recommend trying to go at least a week without it.

### Why

First, centralized filesystems are difficult/very costly to run and AFS does scale well, but it is slower than a local fs and has difficulty synchronising many changes across the network.
(One project which heavily suffers from this is Ganga).

On top of this it's a technology which is not being supported in the mid to long term so I would advise jumping ship now as there are already several good reasons to.

### Start here

I'm writing this assuming you've already got a CERN VM. (openstack.cern.ch) if you've not done this there are lots of guides on what to do to get one setup. e.g. `http://information-technology.web.cern.ch/sites/information-technology.web.cern.ch/files/OpenStack%20training.pdf`
or: `https://clouddocs.web.cern.ch/clouddocs/tutorial_using_a_browser/index.html`

Once you have your VM, remember to update it!
```[bash]
apt-get update
apt-get upgrade
```

Now, we need to get several technologies working so that we can do LHCb tasks.

 1. CVMFS
 2. EOS
 3. Additional required packages
 4. Getting into an LHCb env
 5. Avoiding AFS

In order to expedite this I'd recommend first logging in as root to your box using the key you setup the instance with.

### Setting up CVMFS

Following the instructions at: https://cernvm.cern.ch/portal/filesystem/quickstart

```[bash]
yum install cvmfs cvmfs-config-default
cvmfs_config setup
mkdir -p /etc/cvmfs
echo 'CVMFS_REPOSITORIES=lhcb.cern.ch,ganga.cern.ch' >> /etc/cvmfs/default.local
echo 'CVMFS_HTTP_PROXY="http://ca-proxy.cern.ch:3128"' >> /etc/cvmfs/default.local
cvmfs_config probe
```

### Setting up EOS

Following the instructions at: https://twiki.cern.ch/twiki/bin/view/EOS/EosClientInstall

```[bash]
echo 'export PATH=$PATH:/afs/cern.ch/project/eos/installation/lhcb/bin' >> /etc/bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/afs/cern.ch/project/eos/installation/lhcb/lib64' >> /etc/bashrc
echo 'export EOS_MGM_URL=root://eoslhcb.cern.ch' >> /etc/bashrc
yum install openssl098e libssl
ln -sf /usr/lib64/libreadline.so.6 /usr/lib64/libreadline.so.5
```
(NB: The final line here is potentially unsafe but it's needed on CENTOS7 and the ABI hasn't changed much so this is OK for the 99% of use cases I've come across)


#### Setting up missing packages

**Essential**:
This is a short list of RPMs which are not part of the default install but LHCb expects to be able to use:
```[bash]
yum install git svn make gcc gcc-c++ cern-get-sso-cookie make ninja-build ccache screen python2-ipython_genutils rsync vim
```

**Optional**
nice packages to also install:
```[bash]
yum install htop iftop iotop vim valgrind python2-pip 
```
nice env change(s):
```[bash]
echo 'alias vi=vim' >> /etc/bashrc
```


### Getting into the LHCb env (cvmfs)

This step drops all users of this VM into the LHCb CVMFS environment.
```[bash]
echo 'export X509_CERT_DIR=/cvmfs/lhcb.cern.ch/etc/grid-security/certificates' >> /etc/bashrc
echo 'export CMTCONFIG=x86_64-slc6-gcc49-opt' >> /etc/bashrc
echo 'source /cvmfs/lhcb.cern.ch/group_login.sh' >> /etc/bashrc
```

### Avoid AFS (Optional)

Now, still logged in as root you want to edit the following file:
```[bash]
vim /etc/passwd
```
Find the line which has your CERN username (for me):
```[bash]
rcurrie:x:54830:1470:Robert Andrew Currie,2 1-028,+41227674263,:/afs/cern.ch/user/r/rcurrie:/bin/bash
```
Edit it to look like:
```[bash]
rcurrie:x:54830:1470:Robert Andrew Currie,2 1-028,+41227674263,:/home/rcurrie:/bin/bash
```

Now make a home dir:
```[bash]
mkdir -p /home/rcurrie
chown -R rcurrie /home/rcurrie
echo 'source /etc/bashrc' >> /home/rcurrie/.bashrc
```

Also we want to disable the AFS sourcing of our tools when we login with our user account:
```
mv /etc/profile.d/zzz_hepix.sh{,.bak}
```
**BEWARE**! I don't know/care what this script does I just know I don't want to run it anymore!

### Testing your new VM

First login as your user account on the VM.

Now lets try building something like Moore:
```[bash]
# Setup the initial template files needed by the LHCb tools
lb-dev Moore/v26r0
cd MooreDev_v26r0/

# git init and setup the remote
git lb-use Moore

# checkout the 'Hlt' folder from the 'v26r0' tag of the Moore repo
git lb-checkout Moore/v26r0 Hlt

# Build it using as much CPU as we can get
make -j

# Lets run some tests
make test
```

### Test submitting a grid job

```[bash]
echo 'j=Job(backend=Dirac());j.submit()' >> /tmp/tmpJob.sh
lb-run ganga/v603r1 ganga /tmp/tmpJob.sh
```

### Removing AFS (For the very brave)

As root again on the box.
```
umount /afs
rmmod openafs
yum remove openafs
```

This will ensure that your system is AFS free but you may catch the odd hard-coded AFS path which still remains.
