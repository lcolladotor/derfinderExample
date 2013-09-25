#!/bin/sh

# Directories
MAINDIR=/amber2/scratch/lcollado/derfinderExample
WDIR=${MAINDIR}/fullCoverage
DATADIR=${MAINDIR}/thout

# Define variables
SHORT='fullCov-derEx'
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
R-devel -e "library(derfinder2); dirs <- makeBamList(datadir='${DATADIR}', samplepatt='RR'); cores <- ${CORES}; source('fullCoverage.R')"

## Move log files into the logs directory
mv ${SHORT}.* ${WDIR}/logs/

echo "**** Job ends ****"
date
EOF

## Memory limits set assuming 24 cores will be used
call="qsub -cwd -l jabba,mem_free=72G,h_vmem=10G,h_fsize=10G -pe local ${CORES} -N ${SHORT} -m e ${WDIR}/.${SHORT}.sh"
echo $call
$call
