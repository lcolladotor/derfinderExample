#!/bin/sh

# Directories
MAINDIR=/amber2/scratch/lcollado/derfinderExample
WDIR=${MAINDIR}/derCoverageInfo
DATADIR=${MAINDIR}/thout

# Define variables
SHORT='fullCov-derEx'

## If you have enough cores, use 1 per chr
CORES=24

# Construct shell file
echo "Creating script for loading the Coverage data"
cat > ${WDIR}/.${SHORT}.sh <<EOF
#!/bin/bash	
echo "**** Job starts ****"
date

# Make logs directory
mkdir -p ${WDIR}/logs

# Load the data, save the coverage without filtering, then save each file separately
Rscript-devel ${WDIR}/derfinder2-fullCoverage.R -d "${DATADIR}" -p "RR" -c 5 -m ${CORES} -n TRUE -v TRUE

## Move log files into the logs directory
mv ${SHORT}.* ${WDIR}/logs/

echo "**** Job ends ****"
date
EOF

## Memory limits set assuming 24 cores will be used
call="qsub -cwd -l jabba,mem_free=100G,h_vmem=20G,h_fsize=30G -pe local ${CORES} -N ${SHORT} -m e ${WDIR}/.${SHORT}.sh"
echo $call
$call
