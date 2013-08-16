#!/bin/bash
#$ -cwd	
#$ -m e
#$ -l jabba,mem_free=30G,h_vmem=100G
#$ -N derEx-mergeCov

echo "**** Job starts ****"
date

# merge
Rscript mergeCov.R

echo "**** Job ends ****"
date
