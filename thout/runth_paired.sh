#!/bin/sh

# Directories
MAINDIR=/dcs01/lieber/ajaffe/Brain/derRuns/derfinderExample
WDIR=${MAINDIR}/thout
DATADIR=${MAINDIR}/reads

# Define variables
P=4
GENOMEINDEX=${MAINDIR}/ref/Homo_sapiens/Ensembl/GRCh37/Sequence/Bowtie2Index/genome
GENES=${MAINDIR}/ref/Homo_sapiens/Ensembl/GRCh37/Annotation/Archives/archive-2011-01-27-19-20-47/Genes/genes.gtf

# Change to data dir
cd $DATADIR

# Construct shell files
cat paired.txt | while read x
	do
	cd ${WDIR}
	libname=$(echo "$x" | cut -f3)
	# Setting paired file names
	file1=$(echo "$x" | cut -f1)
	file2=$(echo "$x" | cut -f2)
	# Actually create the script
	echo "Creating script for file $fastq corresponding to $libname"
	cat > ${WDIR}/.${libname}.th.sh <<EOF
#!/bin/bash	
echo "**** Job starts ****"
date

# run tophat
# 100 - 37 * 2 = 26 (got the 100 from find_insert_size.R)
# sd is 51.65 =~ 52
tophat -p ${P} -G ${GENES} --mate-inner-dist 26 --mate-std-dev 52 -o ${libname} ${GENOMEINDEX} ${DATADIR}/${file1} ${DATADIR}/${file2}

mv ${libname}.* ${libname}/
echo "**** Job ends ****"
date
EOF
	call="qsub -cwd -l mem_free=25G,h_vmem=7G,h_fsize=20G -pe local $P -N ${libname}.th -m e ${WDIR}/.${libname}.th.sh"
	echo $call
	$call
done
