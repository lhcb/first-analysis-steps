---
layout: page
title: First Steps in LHCb
subtitle: Developing LHCb Software
minutes: 10
---

> ## Learning Objectives {.objectives}
> * Learn the basics of how to work with and modify LHCb software packages

This lesson introduces you to two commands:

 - `lb-dev` for setting up a new development environment
 - `getpack` for downloading LHCb software packages

If you want to make changes to a software package, you will need to set up a development environment. `lb-dev` is your friend here:

```bash
lb-dev --name DaVinciDev DaVinci v40r2
```

The output should look similar to this:

```
Successfully created the local project DaVinciDev in .

To start working:

  > cd ./DaVinciDev
  > getpack MyPackage vXrY

then

  > make
  > make test
  > make QMTestSummary

and optionally

  > make install

You can customize the configuration by editing the files 'CMakeLists.txt'
(see http://cern.ch/gaudi/CMake for details).
```

Follow those instructions and once you've compiled your software run

```bash
./run bash
```

inside the directory. This will (similar to `lb-run`) give you a new bash session with the right environment variables.

Your new development environment won't be very useful without any software to modify and build.
So why not check out out one of the existing LHCb packages, which are stored in the LHCb SVN repository?

Let's assume you have already used `lb-dev` to set up your development environment and you are currently inside it.
In order to obtain the source code of the package you want to work on, use `getpack`.
This is an LHCb-aware wrapper around SVN.
For example, if you want to write a custom stripping selection, execute the following in the `DaVinciDev` directory:

```bash
getpack Phys/StrippingSelections head
```

Under the hood, `getpack` will `svn checkout` (≈ `git clone`) the corresponding SVN repository.
The first argument to `getpack` is the name of the package you want to checkout, while the second argument allows you to choose a specific branch.
`head` is usually the one one that contains the newest development changes and the one you should commit new changes to.

You can now modify the `StrippingSelections` package and run `make` to build it with your changes.
You can test your changes with the `./run` script.
It works similar to `lb-run`, without the need to specify a package and version:
```bash
./run gaudirun.py options.py
```

> ## What if getpack asks for my password 1000 times? {.callout}
> 
> In general, since your home directoy on lxplus is on `afs`, you need a valid `afs`
> token to access it. Such a token can only be obtained when logging in with password
> or with a kerberos-based authentication, and not when using public keys.
> Since an `afs` token is not needed when communicating with the `svn` server,
> public key-based authentication can be used in this particular case.
>
> To avoid `getpack` asking you for your password several times, you need to
> configure your `ssh` following the instructions
> [here](http://information-technology.web.cern.ch/book/how-start-working-svn/accessing-svn-repository#accessing-sshlinux).
> The summary of these instructions follows:
>
>  1. Generate `ssh keys` (`ssh-keygen -t rsa` or `ssh-keygen -t dsa`).
>  2. Copy your public `ssh` key to lxplus (`scp ~/.ssh/*.pub USERNAME@lxplus.cern.ch:~`).
>  3. Execute the `ssh` setup script `/afs/cern.ch/project/svn/public/bin/set_ssh`.
>  4. Setup your local `.ssh/config` file with
> 
>     ```
>     Host lxplus.cern.ch lxplus 
>     Protocol 2 
>     PubkeyAuthentication no 
>     PasswordAuthentication yes
>     
>     Host svn.cern.ch svn 
>     PubkeyAuthentication yes
>     GSSAPIAuthentication yes 
>     GSSAPIDelegateCredentials yes 
>     Protocol 2 
>     ForwardX11 no
>     ```
>  5. Now check that you can login to `svn.cern.ch` without password (you will immediately get logged out).
>
>     ```
>     ******************************************************************************* 			
>     *                                                                             
>     *	Reminder: You have agreed to comply with the CERN computing rules         
>     *				http://cern.ch/ComputingRules                                 
>     *			                                                                  
>     *******************************************************************************
>     SVN server - only svn allowed, interactive login disabled 
>     Connection to svn closed.
>     ```
>
> And you're set!

If you just want to take a look at a source file, without checking it out, you can comfortably access the repository through two different web UIs.

 * [Trac](https://svnweb.cern.ch/trac/lhcb/)
 * [SVNweb](http://svnweb.cern.ch/world/wsvn/lhcb)

(which one to use? It is just a matter of taste, pick the one that looks nicest)

To get an idea of how a certain component of the LHCb software works, you can access its doxygen documentation.
There is a page for each project, lists of projects can be found here:

 * [https://lhcb-release-area.web.cern.ch/LHCb-release-area/DOC/davinci/latest_doxygen/index.html](https://lhcb-release-area.web.cern.ch/LHCb-release-area/DOC/davinci/latest_doxygen/index.html).
 * [http://lhcb-comp.web.cern.ch/lhcb-comp/](http://lhcb-comp.web.cern.ch/lhcb-comp/)

Another useful tool available on lxplus machines is `Lbglimpse`. It allows you to search for a given string in the source code of LHCb software.
```bash
Lbglimpse "PVRefitter" DaVinci v40r2
```
It works with every LHCb project and released version.

If you have made changes that are supposed to be integrated into the official LHCb repositories, you can use `svn commit`.
But read the instructions in the SVN usage guidelines first.

 * [SVNUsageGuidelines](https://twiki.cern.ch/twiki/bin/view/LHCb/SVNUsageGuidelines)

Be advised that you should always communicate with the package maintainers before committing changes!
The release managers have to find the packages to include in a new release. Therefore make sure
to document your changes in the release notes which are found in `doc/release.notes`.
After that put your commit into the tag collector.

 * [Tag collector FAQ](https://twiki.cern.ch/twiki/bin/view/LHCb/FAQ/TagCollectorFAQ)
 * [LHCb Tag Collector](https://lhcb-tag-collector.web.cern.ch/lhcb-tag-collector/index.html)

(The login button is in the top right corner.)

It is advisable to test new developments on the so-called nightly builds.
They take everything which is committed in the head versions of all packages
and try to build the given project.
You can checkout this version by doing:
```bash
lb-dev DaVinci HEAD --nightly lhcb-head 
```
A more detailed description of the command is found here:

 * [SoftwareEnvTools](https://twiki.cern.ch/twiki/bin/view/LHCb/SoftwareEnvTools)

Sometimes mistakes happen and the committed code is either not compiling or does not do what it is supposed to do.
Therefore the nightly tests are performed. They first try to build the full software stack.
If that is successful, they run some reference jobs and compare the output of the new build with a reference file.
The results of the nightly builds can be found here.

* [Nightly tests](https://buildlhcb.cern.ch/nightlies/)

If the aim of the commit was to change the ouput, e.g. because you increased the
track reconstruction efficiency by a factor of two, inform the release manager of the package
such that he can update the reference file.


