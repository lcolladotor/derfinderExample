#!/bin/sh

## Usage
# sh der2Merge.sh run1-v0.0.28

# Directories
MAINDIR=/dcl01/lieber/ajaffe/derRuns/derfinderExample
WDIR=${MAINDIR}/derAnalysis

# Define variables
SHORT='der2M-Ex'
PREFIX=$1

# Construct shell files
outdir="${PREFIX}"
sname="${SHORT}.${PREFIX}"
echo "Creating script ${sname}"
cat > ${WDIR}/.${sname}.sh <<EOF
#!/bin/bash	
echo "**** Job starts ****"
date

mkdir -p ${WDIR}/${outdir}/logs

# merge results
Rscript -e "library(derfinder); load('/dcl01/lieber/ajaffe/derRuns/derfinderExample/derGenomicState/GenomicState.Hsapiens.UCSC.hg19.knownGene.Rdata'); mergeResults(prefix='${PREFIX}', genomicState=GenomicState.Hsapiens.UCSC.hg19.knownGene)"

# Move log files into the logs directory
mv ${WDIR}/${sname}.* ${WDIR}/${outdir}/logs/

echo "**** Job ends ****"
date
EOF
call="qsub -cwd -l jabba,mem_free=50G,h_vmem=100G,h_fsize=10G -N ${sname} -m e .${sname}.sh"
echo $call
$call