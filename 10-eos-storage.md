---
layout: page
title: First steps in LHCb
subtitle: Getting your data onto EOS
minutes: 10
---

> ## Learning Objectives {.objectives}
>
> * Run a ganga job which puts output onto EOS
> * Open and view the files on EOS

Because you have only 100 Gb of AFS workspace, you will need to put most large
data files and ntuples somewhere else. Unless your own institute has a large computing
cluster and runs LHCb software locally, the most convenient place is EOS. You get
2 Tb of space which is allocated to you, and this is disk space so you do not
have to wait for files to be staged or replicated. 

Note that this tutorial aims to teach you a workflow which is particularly convenient
for getting your data accessible to interactive analysis on lxplus, or analysis on lxbatch.
It is perfectly possible to have a different workflow in which all data goes to
the grid. You could then do all your work through ganga, although you cannot work interactively
in this case. You could also replicate the grid files onto the CERN grid user area,
which is also on EOS, or to your home institute. That may be a better workflow for some
use cases, and should be covered in a separate tutorial.

The first thing you will want to do is tell ganga where to put the files. Look for a line like
the following in your .gangarc file

```python
MassStorageFile = {'fileExtensions': [''], 'uploadOptions': {'path': '/eos/lhcb/user/g/gligorov',
'cp_cmd': '/afs/cern.ch/project/eos/installation/lhcb/bin/eos.select cp', 'ls_cmd':
'/afs/cern.ch/project/eos/installation/lhcb/bin/eos.select ls', 'mkdir_cmd': 
'/afs/cern.ch/project/eos/installation/lhcb/bin/eos.select mkdir'}, 
'backendPostprocess': {'LSF': 'WN', 'Dirac': 'client', 'LCG': 'client', 'ARC': 'client', 
'CREAM': 'client', 'Localhost': 'WN', 'Interactive': 'client'}}
```
you should see everything there already except for the 'path' which you should set to your
eos home area. 

Notice that you can use 'fileExtensions' to control which types of files go to MassStorage.
This line actually goes hand in hand with another line

```python
DiracFile = {'fileExtensions': ['*.dst'], 'uploadOptions': {}, 'backendPostprocess':
{'LSF': 'WN', 'Dirac': 'WN', 'LCG': 'WN', 'CREAM': 'WN', 'Localhost': 'WN', 'Interactive': 'WN'}}
```

which tells ganga which file types should **not** go to mass storage but to the GRID instead.
Typically you want to leave '.dst' files, which are very large and normally slow to process
interactively, on the GRID and you want to put '.root' files like ntuples on MassStorage,
but as always you should consider your own workflow and figure out what works best for you.

That much for the ganga part. Now you want to tell a specific ganga job to put files
on EOS. Consider the following example

```python
    j = Job( application = DaVinci( version = 'v36r2' ) ) 
    j.application.user_release_area = "/afs/cern.ch/user/g/gligorov/cmtuser"
    j.application.platform = "x86_64-slc6-gcc48-opt"
    j.name = 'Sim08f D2KK off reco. , all files'
    j.comment = 'Sim08f D2KK off reco. '
    j.application.optsfile = [File(script)]
    j.inputdata = j.application.readInputData(datacard+".py")
    j.backend = Dirac()
    j.splitter=SplitByFiles(filesPerJob=100, ignoremissing=True, maxFiles=None)
    f = MassStorageFile("*D2*.root")
    f.outputfilenameformat = "/Sim08f/D2KK/{sjid}_{fname}"
    j.outputfiles = [f] 
```
the key lines are the final three. The first one creates a MassStorageFile object
with a regexp which matches the name of the ntuple which is produced by your DaVinci
job. The second line is the directory path within your eos home directory where
the files will finish, so that the full location is in fact

```python
/eos/lhcb/user/g/gligorov/Sim08f/D2KK/"+polarity+"_{sjid}_{fname}
```
the '{sjid}' and '{fname}' are special strings which insert the ganga
subjob ID and your ntuple filename into your outputfile name. This is
how you get ganga to dump the ntuples from all your subjobs into one 
directory with a human readable name. You can of course add other prefixes
and suffixes to the string, reverse the order, etc.

The final line tells your ganga job that the 'outputfiles' of the job are
these MassStorageFiles, i.e. it links the MassStorageFile object which defines
the files it applies to and their outputlocation to the ganga job which
then uses this object to direct the output.
