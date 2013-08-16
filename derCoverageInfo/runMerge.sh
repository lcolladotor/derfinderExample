#!/bin/bash
#$ -cwd	
#$ -m e
#$ -l jabba,mem_free=6G,h_vmem=10G
#$ -N derEx-mergeCov

echo "**** Job starts ****"
date

# merge
Rscript mergeCov.R

echo "**** Job ends ****"
date
