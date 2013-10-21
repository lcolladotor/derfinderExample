#!/bin/bash
#$ -cwd	
#$ -m e
#$ -l jabba,mem_free=50G,h_vmem=100G
#$ -N mergeFull-derEx

echo "**** Job starts ****"
date

# merge
mkdir -p ../derCoverageInfo
Rscript mergeFull.R

echo "**** Job ends ****"
date