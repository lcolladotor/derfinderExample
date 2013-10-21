Explanation of files
====================

This folder has the scripts for extracting the un-filtered coverage information from the BAM files. It also generates the filtered data in ../derCoverageInfo. This is an alternative way to how the data is loaded and filtered in [derCoverageInfo](https://github.com/lcolladotor/derfinderExample/tree/master/derCoverageInfo). Doing it this way requires less memory, but you also have less control on how many files you want to read be reading at a single time. This could matter if someone else needs access to the same disk server. 

# der2FullCovByChr.sh

This shell script loads the un-filtered data and creates an Rdata file for each chromosome.

# der2FilterByChr.sh

This shell script takes the previous output and filters the data. The Rdata files are saved in ../derCoverageInfo.

# mergeFull.R

This R script merges the output from der2FullCovByChr.sh and creates the Rdata file ../derCoverageInfo/fullCov.Rdata This is a list where each element contains the un-filtered data from a chromosome.

## runMerge.sh

Helper shell script used to run mergeFull.R

# mergeFilt.R

This R script merges the output from der2FilterByChr.sh and creates the Rdata file ../derCoverageInfo/filteredCov.Rdata

## runMergeFilt.sh

Helper shell script used to run mergeFilt.R
