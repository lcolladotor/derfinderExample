## Calculate the library adjustments and build the models

## Available at https://github.com/lcolladotor/derfinder
library("derfinder")

## Load the coverage information
load("../../derCoverageInfo/filteredCov.Rdata")

## Identify the sampledirs
dirs <- colnames(filteredCov[[1]]$coverage)

##### Note that this whole section is for defining the models using makeModels()
##### You can alternatively define them manually and/or use packages such as splines if needed.

## The information table for this data set is included in derfinder
info <- genomeInfo

## Match dirs with actual rows in the info table
match <- sapply(dirs, function(x) { which(info$run == x)})
info <- info[match, ]

## Define the groups
group <- genomeInfo$pop
adjustvars <- data.frame(genomeInfo$gender)

## Define the library size adjustments
sampleDepths <- sampleDepth(fullCov=filteredCov, prob=0.9, nonzero=TRUE, center=FALSE, colsubset=NULL, verbose=TRUE)
save(sampleDepths, file="sampleDepths.Rdata")

## Build the models
models <- makeModels(sampleDepths=sampleDepths, testvars=group, adjustvars=adjustvars, testIntercept=FALSE)
save(models, file="models.Rdata")

## Save information used for analyzeChr(groupInfo)
groupInfo <- group
save(groupInfo, file="groupInfo.Rdata")

## Done :-)
proc.time()
sessionInfo()
