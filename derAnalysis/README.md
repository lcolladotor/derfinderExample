Explanation of files
====================

# derfinder2-analysis.R

This R script is the main script for running the `derfinder2` analysis pipeline. It runs the main steps `makeModels()`, `preprocessCoverage()`, `calculateStats()`, `calculatePvalues()` and ends with `annotateNearest()` from the `bumphunter` package.

The script is written in such a way that each step of the pipeline is timed as this information can be useful later on. When running `derfinder2` yourself you will have to modify this script in such a way that the models are constructed according to your own data. Most of the other steps will remain untouched, except for options like cutoffs.

# der2Analysis.sh

This shell script runs `derfinder2-analysis.R`. A very important option in this script is the number of cores. Note that `derfinder2-analysis.R` is written in such a way that the data is split in relation to the number of cores chosen. This will affect how much RAM is used and as such it is important to check the largest chromosomes (say chromosome 1 in human) to see how many rows each chunk will use: roughly total number of rows divided by the number of cores used. 

Another easy to change option is the PREFIX. This is the where the output from the run will be saved and can be useful if you are exploring the results under different models.

This script creates several hidden shell scripts that are then submitted to the cluster.

# derfinder2-merge.R

This R script merges the output from `derfinder2-analysis.R` that is then used in `basicExploration.Rmd`. Pretty much the only option you need to change is the PREFIX.

# basicExploration.Rmd

This R markdown file generates an HTML report exploring the basic results from the `derfinder2` analysis pipeline. It is rather long (500+ lines) and we recommend building your own advanced report after exploring the results with this one.

# basicExplore-run1.sh

This shell script runs `basicExploration.Rmd` via [knitrBootstrap](https://github.com/jimhester/knitrBootstrap). Note that the number of cores used can have dramatic consequences on the amount of RAM used: a big chunk comes from loading `../fullCoverage/fullCov.Rdata` when the data set is rich in samples and/or coverage depth.

This shell script is written for the default PREFIX _run1_. We recommend making copies of this script for other prefixes.

It creates a hidden shell script that is then submitted to the cluster.
