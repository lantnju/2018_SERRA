#!/bin/bash
#
#$ -cwd
#$ -N runmodel_2th_mend
## Name of your job, which you use to identify your job when you type 'qstat' command.
#$ -j y
#$ -S /bin/bash
#
### Submits to queue designated by <queue_name>.
#$ -q  hydro.q
mf2k mf2k.nam
./mt3d.exe
pm.exe < PM/head.txt
pm.exe < PM/concen1.txt
