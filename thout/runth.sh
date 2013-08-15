#!/bin/sh

# Directories
MAINDIR=/amber2/scratch/lcollado/derfinderExample
WDIR=${MAINDIR}/thout
DATADIR=${MAINDIR}/reads

# Define variables
P=4
GENOMEINDEX=${MAINDIR}/ref/Homo_sapiens/Ensembl/GRCh37/Sequence/Bowtie2Index/genome
GENES=${MAINDIR}/ref/Homo_sapiens/Ensembl/GRCh37/Annotation/Archives/archive-2011-01-27-19-20-47/Genes/genes.gtf

# Change to data dir
cd $DATADIR

# Construct a single files.txt from all the files
cat files*.txt > files.txt

# Construct shell files
for fastq in *fastq.gz
do
	cd ${WDIR}
	# New naming scheme
	libname="${fastq%.fastq*}"
	# Old one:
	# libname=$(grep ${fastq} ${DATADIR}/files.txt | cut -f 8)
	echo "Creating script for file $fastq corresponding to $libname"
	cat > ${WDIR}/.${libname}.th.sh <<EOF
#!/bin/bash	
echo "**** Job starts ****"
date

# run tophat
tophat -p ${P} -G ${GENES} -o ${libname} ${GENOMEINDEX} ${DATADIR}/${fastq}

mv ${libname}.* ${libname}/
echo "**** Job ends ****"
date
EOF
	call="qsub -cwd -l mem_free=15G,h_vmem=5G,h_fsize=20G -pe local $P -N ${libname}.th -m e ${WDIR}/.${libname}.th.sh"
	echo $call
	$call
done
