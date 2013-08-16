Explanation of files
====================

# derCoverageInfo.sh

This shell script runs `S derfinder2` data processing steps: `S makeBamList()` and `S loadCoverage()`. The coverage cutoff used is set to 5 and the output files will later be used in `../derAnalysis`.

It creates several hidden shell scripts that are then submitted to the cluster.

# mergeCov.R

This R script merges the output from `derCoverageInfo.sh` into `covList.Rdata`. This file might be useful for other downstream purposes like plotting.

The shell script `runMerge.sh` is just a helper script.
