#!/bin/bash
#$ -cwd	
#$ -m e
#$ -l jabba,mem_free=50G,h_vmem=100G
#$ -N mergeFilt-derEx

echo "**** Job starts ****"
date

# merge
Rscript mergeFilt.R

echo "**** Job ends ****"
date