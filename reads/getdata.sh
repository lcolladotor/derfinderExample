#! /bin/bash
#$ -j y
#$ -m e
#$ -N hapmapdata
date
R CMD BATCH getdata.R
date
