---
layout: page
title: First Steps in LHCb
subtitle: Interactively exploring a DST
minutes: 10
---
> ## Learning Objectives {.objectives}
>
> * Open a DST in an interactive python session
> * Print all nodes in a DST
> * Explore the contents of the TES
> * Inspect a track
> * Inspect a stripping location 

Data is stored in files called DSTs, which are processed
by DaVinci to make nTuples. However you can also explore
them interactively from a python session.

This is particularly useful if you want to quickly find
something out, or the more complex processing in DaVinci
is not working as expected.

The file we [downloaded from the grid](05-files-from-grid.html)
contains simulated data, with stripping and trigger decisions
and so on. Here we assumed the file you downloaded is called `00035742_00000002_1.allstreams.dst`.
To take a look at the contents of the TES, we can use a script from Bender called dst-explorer,
which can be run in a terminal like this:

```bash
$ lb-run Bender v25r6 dst-explorer 00035742_00000002_1.allstreams.dst
```
or
```bash
$ lb-run Bender v25r6 dst-explorer /lhcb/MC/2012/ALLSTREAMS.DST/00035742/0000/00035742_00000002_1.allstreams.dst
```
which will open a remote file using the LFN.

This will open the DST. We are now ready to explore the TES,
using the `ls` and `get` methods.  For example you could
look at the properties of some tracks for the first event by typing
inside the python session:

```python
tracks = get("Rec/Track/Best")
print tracks[0]
```

The next question is, how do you know what TES locations that could
exist? `ls()` prints a few of them, but not all.
In addition there are some special ones that only exist if you try to
access them, those are added to the list when calling `ls(ondemand=True).
`ls(forceload=True)` will also try to load all sub-paths.

`ls(ondemand=True, forceload=True)` will list a large number of TES
locations, but even so there are some which you have to know about.
Another oddity is that some locations are "packed", for example:
`/Event/AllStreams/pPhys/Particles`.
You can not access these directly at this location. Instead you
have to know what location the contents will get unpacked to when
you want to use it. Often you can just try removing the small `p`
from the location (`/Event/AllStreams/Phys/Particles`).

You can also inspect the particles and vertices built by your stripping
line. However not every event will contain a candidate for your line,
one of the methods in dst-explorer, `seekStripDecision` will advance us
until the stripping decision was positive, e.g.

```python
seekStripDecision(".*D2hhCompleteEventPromptDst2D2RSLine.*")
```

The candidates built for you can now be found at `/Event/AllStreams/Phys/D2hhCompleteEventPromptDst2D2RSLine/Particles`
(the leading `/Event/` can be left out when retrieving event data from the TES):

```python
cands = get("AllStreams/Phys/D2hhCompleteEventPromptDst2D2RSLine/Particles")
print cands.size()
```

This tells you how many candidates there are in this event and you can access the first
one with:

```python
print cands[0]
```

Which will print out some information about the [Particle](http://lhcb-release-area.web.cern.ch/LHCb-release-area/DOC/davinci/releases/v36r6/doxygen/d0/d13/class_l_h_cb_1_1_particle.html#details). In our case a D*.
