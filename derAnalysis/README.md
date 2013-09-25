Explanation of files
====================

This folder has the scripts for running the main parts of the __derfinder2__ analysis pipeline and exploring the results in a HTML report.

# derfinder2-analysis.R

This R script is the main script for running the __derfinder2__ analysis pipeline. It runs the main steps of the pipeline by using __analyzeChr()__ which is a wrapper for running __makeModels()__, __preprocessCoverage()__, __calculateStats()__, __calculatePvalues()__ and ends with __annotateNearest()__ from the __bumphunter__ package.

The script is written in such a way that each step of the pipeline is timed as this information can be useful later on. When running __derfinder2__ yourself you will have to modify this script in such a way that the models are constructed according to your own data. Special attention should be payed to options like cutoffs.

# der2Analysis.sh

This shell script runs `derfinder2-analysis.R`. A very important option in this script is the number of cores. Note that `derfinder2-analysis.R` is written in such a way that the data is split in relation to the number of cores chosen. This will affect how much RAM is used and as such it is important to check the largest chromosomes (say chromosome 1 in human) to see how many rows each chunk will use: roughly total number of rows divided by the number of cores used. 

Another easy to change option is the PREFIX. This is the where the output from the run will be saved and can be useful if you are exploring the results under different models.

This script creates several hidden shell scripts that are then submitted to the cluster.

# der2Merge.sh

This shell script loads the genomic state information and then merges the output from `derfinder2-analysis.R` by running __mergeResults()__. It generates all the results needed for running __generateReport()__

# der2Report.sh

This shell script runs __generateReport()__ and creates the HTML report.
