#!/bin/bash

#$ -cwd
#$ -l jabba,mem_free=50G,h_vmem=100G,h_fsize=40G 
#$ -N genState
#$ -m e

echo "**** Job starts ****"
date

mkdir -p logs

R -e "library(derfinder2); library('TxDb.Hsapiens.UCSC.hg19.knownGene'); txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene; GenomicState.Hsapiens.UCSC.hg19.knownGene <- makeGenomicState(txdb=txdb); save(GenomicState.Hsapiens.UCSC.hg19.knownGene, file='GenomicState.Hsapiens.UCSC.hg19.knownGene.Rdata'); proc.time(); sessionInfo()"

mv genState.* logs/

### Done
echo "**** Job ends ****"
date
