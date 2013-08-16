#!/bin/sh

# Directories
MAINDIR=/amber2/scratch/lcollado/derfinderExample
WDIR=${MAINDIR}/derAnalysis
DATADIR=${MAINDIR}/derCoverageInfo

# Define variables
SHORT='der2A-Ex'
P=2
### To chose P consider exploring the number of rows left in each chr
## For example:
## grep filterData ${MAINDIR}/derCoverageInfo/logs/*
### Then determine the balance between how fast you want the analysis to be and how much RAM you have available
PREFIX='run1'

# Construct shell files
for chrnum in 22 21 Y 20 19 18 17 16 15 14 13 12 11 10 9 8 X 7 6 5 4 3 2 1
do
	echo "Creating script for chromosome ${chrnum}"
	chr="chr${chrnum}"
	outdir="${PREFIX}/${chr}"
	cat > ${WDIR}/.${SHORT}.${outdir}.sh <<EOF
#!/bin/bash	
echo "**** Job starts ****"
date

# Create output directory 
mkdir -p ${WDIR}/${outdir}
# Make logs directory
mkdir -p ${WDIR}/${outdir}/logs

# run derfinder2-analysis.R
cd ${WDIR}/${outdir}
Rscript-devel ${WDIR}/derfinder2-analysis.R -d "${DATADIR}/${chr}CovInfo.Rdata" -c "${chrnum}" -m ${P} -v TRUE

# Move log files into the logs directory
mv ${WDIR}/${SHORT}.${chrnum}.* ${WDIR}/${outdir}/logs/

echo "**** Job ends ****"
date
EOF
	call="qsub -cwd -l jabba,mem_free=125G,h_vmem=20G,h_fsize=10G -pe local ${P} -N ${SHORT}.${chrnum} -m e ${WDIR}/.${SHORT}.${chrnum}.sh"
	echo $call
	$call
done
