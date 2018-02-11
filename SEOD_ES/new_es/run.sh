#!/bin/bash
#$ -cwd
#$ -N EnOpt_2D_A_NWE
#$ -j y
#$ -S /bin/bash
#$ -q hydro.q
#
date
matlab -nodesktop -nosplash -r main
date