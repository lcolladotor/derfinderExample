Explanation of files
====================

This folder has the scripts for extracting the un-filtered coverage information from the BAM files. It also generates the filtered data in ../derCoverageInfo. Alternatively, you can load the raw data and process it twice: once without any filter and once with filtering. But doing it this way is useful if you only want to read the raw data once. Check the alternative way which was used earlier [here](https://github.com/lcolladotor/derfinderExample/tree/v0.0.13/fullCoverage).

# der2Fullcoverage.sh

This shell script creates a single hidden shell script that is then submitted to the cluster and runs `derfinder2-fullCoverage.R`.

# derfinder2-fullCoverage.R

This R script runs __derfinder2__ data processing steps: __makeBamList()__, __fullCoverage()__ and __filterData()__. 

* The coverage cutoff used is set to _NULL_ so that no filtering will be done when processing the BAM files. This information is saved for downstream steps such as using __generateReport()__.
* From the unfiltered data, then __filterData()__ is used to filter the information and split it by chromosome for running the processing steps such as __analyzeChr()__.
