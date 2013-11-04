#!/bin/sh

# Directories
MAINDIR=/dcs01/lieber/ajaffe/Brain/derRuns/derfinderExample
WDIR=${MAINDIR}/thout
DATADIR=${MAINDIR}/reads

# Define variables
P=4
GENOMEINDEX=${MAINDIR}/ref/Homo_sapiens/Ensembl/GRCh37/Sequence/Bowtie2Index/genome
GENES=${MAINDIR}/ref/Homo_sapiens/Ensembl/GRCh37/Annotation/Archives/archive-2011-01-27-19-20-47/Genes/genes.gtf

# Construct shell files

cat > ${WDIR}/.check_size.sh <<EOF
#!/bin/bash	
echo "**** Job starts ****"
date

# Using steps from http://molecularevolution.org/resources/activities/velvet_and_bowtie_activity

## According to SRA
# Nominal length: 111, Nominal Std Dev: 53.3
# Read length is 37bp
# So the minimum is 0 and the maximum should be around:
# 111 + 53.3 * 3 + 2 * 37 = 344.9
# 500 (default) will cover all of the extreme cases

## Run Bowtie2
bowtie2 -p ${P} ${GENOMEINDEX} -1 ${DATADIR}/ERR009101_1.fastq.gz -2 ${DATADIR}/ERR009101_2.fastq.gz -I 0 -X 500 -S check_size.sam

# Filter un-aligned reads
awk '$3!="*"' check_size.sam > check_size.filt1.sam
# Removing lines where TLEN is unavailable.
# More at http://samtools.sourceforge.net/SAM1.pdf
# Otherwise the perl script dies out because both reads are assigned the same pos
awk '$9!="0"' check_size.filt1.sam > check_size.filt.sam

# Find distribution
perl get_insert_sizes_from_sam.pl check_size.filt.sam > check_size.sizes

# Generate basic summary stats and plot
Rscript find_insert_size.R

echo "**** Job ends ****"
date
EOF

# Run the script
call="qsub -cwd -l mem_free=20G,h_vmem=6G,h_fsize=20G -pe local $P -N check_size -m e ${WDIR}/.check_size.sh"
echo $call
$call
