#!/bin/sh

## Usage
# sh der2Report.sh run1-v0.0.28

# Directories
MAINDIR=/amber2/scratch/lcollado/derfinderExample
WDIR=${MAINDIR}/derAnalysis

# Define variables
SHORT='der2R-Ex'
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
Rscript -e "library(derfinderReport); load('${MAINDIR}/derCoverageInfo/fullCov.Rdata'); generateReport(prefix='${PREFIX}', browse=FALSE, nBestClusters=20, fullCov=fullCov, device='CairoPNG')"

# Move log files into the logs directory
mv ${WDIR}/${sname}.* ${WDIR}/${outdir}/logs/

echo "**** Job ends ****"
date
EOF
call="qsub -cwd -l jabba,mem_free=50G,h_vmem=100G,h_fsize=10G -N ${sname} -m e .${sname}.sh"
echo $call
$call