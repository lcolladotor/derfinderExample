#!/bin/sh

# Directories
MAINDIR=/amber2/scratch/lcollado/derfinderExample
WDIR=${MAINDIR}/fullCoverage
DATADIR=${MAINDIR}/thout

# Define variables
SHORT='derEx-fullCov'

# Construct shell files
for chrnum in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y
do
	chr="chr${chrnum}"
	echo "Creating script for chromosome ${chr}"
	cat > ${WDIR}/.${SHORT}.${chr}.sh <<EOF
#!/bin/bash	
echo "**** Job starts ****"
date

# Make logs directory
mkdir -p ${WDIR}/logs

# run makeDF()
R-devel -e "library(derfinder2); dirs <- makeBamList(datadir='${DATADIR}', samplepatt='RR'); loadCoverage(dirs=dirs, chr='${chrnum}', cutoff=NULL, output='auto', verbose=TRUE); proc.time(); sessionInfo()"

## Move log files into the logs directory
mv ${SHORT}.${chr}.* ${WDIR}/logs/

echo "**** Job ends ****"
date
EOF
	call="qsub -cwd -l jabba,mem_free=50G,h_vmem=100G,h_fsize=30G -N ${SHORT}.${chr} -m e ${WDIR}/.${SHORT}.${chr}.sh"
	echo $call
	$call
done
