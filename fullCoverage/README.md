Explanation of files
====================

# fullCoverage.sh

This shell script runs `S derfinder2` data processing steps: `S makeBamList()` and `S loadCoverage()`. The coverage cutoff used is set to NULL so that no filtering will be done when processing the BAM files. 

It creates several hidden shell scripts that are then submitted to the cluster.

# mergeFull.R

This R script merges the output from `fullCoverage.sh` into `fullCov.Rdata` which is then used when generating the basicExploration report.

The shell script `runMerge.sh` is just a helper script.
