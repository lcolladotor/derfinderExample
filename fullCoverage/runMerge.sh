#!/bin/bash
#$ -cwd	
#$ -m e
#$ -l jabba,mem_free=8G,h_vmem=16G
#$ -N derEx-mergeFull

echo "**** Job starts ****"
date

# merge
Rscript mergeFull.R

echo "**** Job ends ****"
date
