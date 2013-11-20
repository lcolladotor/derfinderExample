derfinderExample
================

# Introduction

Example on how to use the __[derfinder](https://github.com/lcolladotor/derfinder)__ package using a subset of the data data from the 2010 papers by [Montgomery et al](http://www.ncbi.nlm.nih.gov/pubmed?term=20220756) and [Pickerell et al](http://www.ncbi.nlm.nih.gov/pubmed?term=20220758).

The goal of the repository is to show how to use __derfinder__ with your own data and to help you get started with actually running an full scale analysis with __derfinder__. It also shows how to use __derfinderReport__ for generating an HTML report with the results from __derfinder__.

For documentation related to __derfinder__ itself check [it's GitHub repository](https://github.com/lcolladotor/derfinder) and help files from R `help(package="derfinder")`. Similarly, for __derfinderReport__ check [it's GitHub repository](https://github.com/lcolladotor/derfinderReport).


# Overview

## Setup

A set of HapMap samples was downloaded to [reads](https://github.com/lcolladotor/derfinderExample/tree/master/reads) using information from the HapMap pedigrees in [info](https://github.com/lcolladotor/derfinderExample/tree/master/info). The iGenome human reference needed to run __TopHat__ was downloaded in [ref](https://github.com/lcolladotor/derfinderExample/tree/master/ref). Then the reads were aligned using __TopHat__ in [thout](https://github.com/lcolladotor/derfinderExample/tree/master/thout) and this is the more computer intensive step in the whole analysis.

## derfinder setup

The coverage information was processed using __derfinder__ and prepared for downstream analyses. 

First, the un-filtered coverage was saved in [derCoverageInfo](https://github.com/lcolladotor/derfinderExample/tree/master/derCoverageInfo) as `fullCov.Rdata`. This can be useful later on for making coverage plots to visually inspect whether the method is picking up sensible regions. 

Second, the filtered coverage was saved in [derCoverageInfo](https://github.com/lcolladotor/derfinderExample/tree/master/derCoverageInfo) separately for each chromosome in `chr*CovInfo.Rdata`.

Next, a list with the filtered coverage information by chromosome is saved in [derCoverageInfo](https://github.com/lcolladotor/derfinderExample/tree/master/derCoverageInfo) as `filteredCov.Rdata`. It is needed for running __sampleDepth()__.

All of these files are generated by [der2Fullcoverage.sh](https://github.com/lcolladotor/derfinderExample/tree/master/derCoverageInfo/der2Fullcoverage.sh) which uses [derfinder2-fullCoverage.R](https://github.com/lcolladotor/derfinderExample/tree/master/derCoverageInfo/derfinder2-fullCoverage.R).

Finally, the genomic state information is generated for hg19 based on UCSC knownGene in [derGenomicState](https://github.com/lcolladotor/derfinderExample/tree/master/derGenomicState) by running [makeGenomicState.sh](https://github.com/lcolladotor/derfinderExample/tree/master/derGenomicState/makeGenomicState.sh). This information is ultimately used for running __plotRegionCoverage()__.

## derfinder analysis

The main steps of the __derfinder__ analysis pipeline are carried out in the [derAnalysis](https://github.com/lcolladotor/derfinderExample/tree/master/derAnalysis) folder.

In order to use the same model matrix for all chromosomes, you have to use __sampleDepth()__ and __makeModels()__ (or make the models manually) as it is done in [derfinder2-models.R](https://github.com/lcolladotor/derfinderExample/blob/master/derAnalysis/derfinder2-models.R) which is run by [der2Models.sh](https://github.com/lcolladotor/derfinderExample/blob/master/derAnalysis/der2Models.sh). 

Once the models have been built,  [derfinder2-analysis.R](https://github.com/lcolladotor/derfinderExample/blob/master/derAnalysis/derfinder2-analysis.R) is run by [der2Analysis.sh](https://github.com/lcolladotor/derfinderExample/blob/master/derAnalysis/der2Analysis.sh) in order to find candidate DERs by chromosome. Over the history of this example, this R script has been simplified to basically just running __analyzeChr()__. The richness of your data set (coverage depth and number of samples) and the number of cores needed for wallclock speed purposes will greatly determine how much RAM __derfinder__ will use. On this example data set, chromosome 1 took 16 mins 6 secs and 13.52 GB of RAM with 2 cores. With another richer data set, the same chromosome took 1 hr 14 mins and 128 GB of RAM using 8 cores. Note that in the second case we could have exchanged wallclock time for RAM if we needed to.

Once `derfinder2-analysis.R` has completed its work, [der2Merge.sh](https://github.com/lcolladotor/derfinderExample/blob/master/derAnalysis/der2Merge.sh) is used to merge the results from running __derfinder__ on each chromosome. If __derfinder__ generated millions of null statistics you probably need to use a more stringent cutoff when running __calculatePvalues()__ and the merging will take some time to re-calculate the p-values using the information from all chromosomes.

## HTML report

An HTML report to carry out an exploration of the results can be generated by using __generateReport()__ from the [derfinderReport](https://github.com/lcolladotor/derfinderReport) package. Reports range in the 10 to 40 MB size and the time to generate it depends on the parameter _nBestClusters_ since making the coverage cluster plots takes time using __ggbio__. 

Please download this repository and open [derAnalysis/run1-v0.0.28/basicExploration/basicExploration.html](https://github.com/lcolladotor/derfinderExample/blob/master/derAnalysis/run1-v0.0.28/basicExploration/basicExploration.html) (it needs [derAnalysis/run1-v0.0.28/basicExploration/figure](https://github.com/lcolladotor/derfinderExample/tree/master/derAnalysis/run1-v0.0.28/basicExploration/figure) to open properly) to view the report generated for this example. If you do not want to download the full repository you can view the plots from the report in [derAnalysis/run1-v0.0.28/basicExploration/figure](https://github.com/lcolladotor/derfinderExample/tree/master/derAnalysis/run1-v0.0.28/basicExploration/figure).


# Installation instructions

Get R 3.0.1 or newer from [CRAN](http://cran.r-project.org/).

```S
## If needed
install.packages("devtools")

## Pre-requisites from CRAN
install.packages(c("knitr", "Rcpp", "RcppArmadillo", "ggplot2", "reshape2", "plyr", 
	"microbenchmark", "gridExtra", "data.table", "knitr", "knitcitations",
	"xtable", "RColorBrewer", "scales"))

## Pre-requisites from Bioconductor
source("http://bioconductor.org/biocLite.R")
biocLite(c("IRanges", "GenomicRanges", "Rsamtools", "bumphunter", "biovizBase", "ggbio", "qvalue",
	 "TxDb.Hsapiens.UCSC.hg19.knownGene", "AnnotationDbi", "GenomicFeatures"))

## GitHub dependencies
library(devtools)
install_github("rCharts", "ramnathv", ref="dev")
install_github(username="jimhester", repo="knitrBootstrap")

## derfinder itself
library(devtools)
install_github("derfinder", "lcolladotor")
install_github("derfinderReport", "lcolladotor")

## Other packages used in this example that are not derfinder pre-reqs
install.packages("getopt")
biocLite("SRAdb")
```

Note that the current [Bioconductor](http://www.bioconductor.org/) release version of __bumphunter__ for R 3.0.1 is a few versions before the one required by __derfinder__. The version needed can be installed manually from http://bioconductor.org/packages/2.13/bioc/html/bumphunter.html You can download the source or other binaries.

# 'Watch' for updates

This software is in development, so we highly recommend 'watching' the repository: Click on the top right under `Watch`. You will then receive notifications for issues, comments, and pull requests as described [here](https://help.github.com/articles/notifications).

# Citation

Below is the citation output from using `citation("derfinder")` in R. Please run this yourself to check for any updates on how to cite __derfinder__.

---

To cite package __derfinder__ in publications use:

Leonardo Collado-Torres, Alyssa Frazee, Andrew Jaffe and Jeffrey Leek (2013). derfinder: Fast differential expression analysis of RNA-seq data at base-pair resolution. R package version 0.0.34. https://github.com/lcolladotor/derfinder

A BibTeX entry for LaTeX users is

@Manual{, title = {derfinder: Fast differential expression analysis of RNA-seq data at base-pair resolution}, author = {Leonardo Collado-Torres and Alyssa Frazee and Andrew Jaffe and Jeffrey Leek}, year = {2013}, note = {R package version 0.0.34}, url = {https://github.com/lcolladotor/derfinder}, }
