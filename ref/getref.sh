#! /bin/bash
#$ -j y
#$ -m e
#$ -N refdata
#$ -l h_fsize=50G
date
wget ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Homo_sapiens/Ensembl/GRCh37/Homo_sapiens_Ensembl_GRCh37.tar.gz .
date
tar -zxvf  *gz
date