Explanation of files
====================

This folder has the scripts for extracting the un-filtered coverage information from the BAM files.

# fullCoverage.sh

This shell script runs __derfinder2__ data processing steps: __makeBamList()__ and __loadCoverage()__. The coverage cutoff used is set to _NULL_ so that no filtering will be done when processing the BAM files. 

It creates several hidden shell scripts that are then submitted to the cluster.

# mergeFull.R

This R script merges the output from `fullCoverage.sh` into `fullCov.Rdata` which is then used when generating the basicExploration report.

The shell script `runMerge.sh` is just a helper script.
