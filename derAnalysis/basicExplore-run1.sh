#!/bin/bash	
SHORT="derEx"
PREFIX="run1"
CORES=1

cat > .basicE-${SHORT}.${PREFIX}.sh <<EOF
#!/bin/bash	
#$ -cwd 
#$ -pe local ${CORES}
#$ -l jabba,mem_free=6G,h_vmem=10G,h_fsize=10G
#$ -m e 
#$ -N ${SHORT}basicE-${PREFIX}

echo "**** Job starts ****"
date

# Run the test
mkdir -p ${SHORT}-basicExplore-${PREFIX}
cd ${SHORT}-basicExplore-${PREFIX}
Rscript -e "library(knitrBootstrap); prefix <- '${PREFIX}'; cores <- ${CORES}; knit_bootstrap('../basicExploration.Rmd', output='basicExplore.html', code_style='Brown Paper', chooser=c('boot', 'code'), nav_type='onscreen', show_code=FALSE)"

mv ../${SHORT}basicE-${PREFIX}.* .

echo "**** Job ends ****"
date
EOF
call="qsub .basicE-${SHORT}.${PREFIX}.sh"
echo $call
$call
