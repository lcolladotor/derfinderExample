#! /bin/bash
#$ -j y
#$ -m e
#$ -N hapmapdata_p2
date
R CMD BATCH getdata_part2.R
date
