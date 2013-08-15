#!/bin/bash
for i in *RR*; do echo $i; cd $i; pwd; samtools index accepted_hits.bam ; cd ..; done
