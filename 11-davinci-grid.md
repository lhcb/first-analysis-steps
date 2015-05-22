---
layout: page
title: First Steps in LHCb
subtitle: Run your first grid job
minutes: 10
---
> ## Learning Objectives {.objectives}
>
> * Create a ganga job
> * Submit ganga jobs
> * Waiting for ganga
> * Find the job output

This lesson will teach you how to take the our [minimal DaVinci job](09-minimal-dv-job.html)
and run it on the grid.

`ganga` is the program which you can use to itneract with your grid jobs. Start it with:

```bash
$ SetupProject Ganga
$ ganga
```

After `ganga` has started you will be dropped into something that looks very
much like an `ipython` session. `ganga` is built on top of `ipython` so you can
type anything that is legal `python` in addition to some special commands provided
by `ganga`.

To create your first `ganga` job type the following:

```python
j = Job(application=DaVinci(version='v36r6'))
j.name = "First ganga job"
j.inputdata = j.application.readInputData('data/MC_2012_27163003_Beam4000GeV2012MagDownNu2.5Pythia8_Sim08e_Digi13_Trig0x409f0045_Reco14a_Stripping20NoPrescalingFlagged_ALLSTREAMS.DST')
j.application.optsfile = 'code/11-grid_ntuple.py'
```
