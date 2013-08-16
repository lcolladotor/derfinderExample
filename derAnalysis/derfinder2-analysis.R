## Run derfinder2's analysis steps with timing info

## Load libraries
library("getopt")

## Available at https://github.com/lcolladotor/derfinder2
library("derfinder2")

## Specify parameters
spec <- matrix(c(
	'DFfile', 'd', 1, "character", "path to the .Rdata file with the results from loadCoverage()",
	'chr', 'c', 1, "character", "Chromosome under analysis. Use X instead of chrX.",
	'mcores', 'm', 1, "integer", "Number of cores",
	'verbose' , 'v', 2, "logical", "Print status updates",
	'prof', 'p', 2, "logical", "Run Rprof(). Only works if using 1 core!",
	'help' , 'h', 0, "logical", "Display help"
), byrow=TRUE, ncol=5)
opt <- getopt(spec)

## Testing the script
test <- FALSE
if(test) {
	## Speficy it using an interactive R session and testing
	test <- TRUE
}

## Test values
if(test){
	opt <- NULL
	opt$DFfile <- "/amber2/scratch/lcollado/derfinderExample/derCoverageInfo/chr21CovInfo.Rdata"
	opt$chr <- "21"
	opt$mcores <- 1
	opt$verbose <- NULL
	opt$prof <- NULL
}

## if help was asked for print a friendly message
## and exit with a non-zero error code
if (!is.null(opt$help)) {
	cat(getopt(spec, usage=TRUE))
	q(status=1)
}

## Default value for verbose = TRUE
if (is.null(opt$verbose)) opt$verbose <- TRUE
	
## Default value for profiling
if (is.null(opt$prof)) opt$prof <- FALSE
	
if(opt$prof) {
	Rprof()
}

## Begin timing
timeinfo <- NULL
## Init
timeinfo <- c(timeinfo, list(Sys.time()))

if(opt$verbose) message("Loading Rdata file with the output from loadCoverage()")
load(opt$DFfile)
## Load
timeinfo <- c(timeinfo, list(Sys.time()))

## Make it easy to use the name later assuming the names were generated using output='auto' in loadCoverage()
eval(parse(text=paste0("data <- ", "chr", opt$chr, "CovInfo")))

## Just for testing purposes
if(test) {
	tmp <- data
	tmp$coverage <- tmp$coverage[1:1e6, ]
	library(IRanges)
	tmp$position[which(tmp$pos)[1e6 + 1]:length(tmp$pos)] <- FALSE
	data <- tmp
}

## Identify the sampledirs
dirs <- colnames(data$coverage)

##### Note that this whole section is for defining the models using makeModels()
##### You can alternatively define them manually and/or use packages such as splines if needed.

## The information table for this data set is included in derfinder2
info <- genomeInfo
## Match dirs with actual rows in the info table

match <- sapply(dirs, function(x) { which(info$run == x)})
info <- info[match, ]

## Define the groups
group <- genomeInfo$pop
adjustvars <- data.frame(genomeInfo$gender)

## Save parameters used for running calculateStats
optionsStats <- list(dir=info$dir, group=group, adjustvars=adjustvars)

## Setup
timeinfo <- c(timeinfo, list(Sys.time()))

save(optionsStats, file=paste0("optionsStats-", opt$chr, ".Rdata"))
## saveStatsOpts
timeinfo <- c(timeinfo, list(Sys.time()))

## Build the models
if(opt$verbose) message("Building mod and mod0")
models <- makeModels(coverageInfo=data, group=group, adjustvars=adjustvars, nonzero=TRUE, verbose=opt$verbose)

## buildModels
timeinfo <- c(timeinfo, list(Sys.time()))

## Save the model matrices
save(models, file=paste0("models-", opt$chr, ".Rdata"))
## saveModels
timeinfo <- c(timeinfo, list(Sys.time()))

######### End of the building models section ###########


## pre-process the coverage data with automatic chunks depending on the number of cores
if(opt$verbose) message("Pre-processing the coverage data")
prep <- preprocessCoverage(coverageInfo=data, cutoff=5, colsubset=NULL, scalefac=32, chunksize=NULL, mc.cores=opt$mcores, verbose=opt$verbose)

## prepData
timeinfo <- c(timeinfo, list(Sys.time()))

## Save the prepared data
save(prep, file=paste0("prep-", opt$chr, ".Rdata"))
## savePrep
timeinfo <- c(timeinfo, list(Sys.time()))

## Run calculateStats
if(opt$verbose) message("Calculating statistics")
fstats <- calculateStats(coveragePrep=prep, models=models, mc.cores=opt$mcores, verbose=opt$verbose)

## calculateStats
timeinfo <- c(timeinfo, list(Sys.time()))

## Save the output from calculateStats
save(fstats, file=paste0("fstats-", opt$chr, ".Rdata"))

## saveStats
timeinfo <- c(timeinfo, list(Sys.time()))

## Calculate p-values and find regions
if(opt$verbose) message("Calculating pvalues")
	
## Choose the cutoff
cutoff <- quantile(as.numeric(fstats), 0.99)
if(opt$verbose) message(paste("The 99th percentile of fstats is", cutoff))

## Use a theoretical cutoff from the F distribution
## Note that this can be useful if you want to use a single 'sensible' cutoff across all chromosomes
n <- dim(models$mod)[1]
df1 <- dim(models$mod)[2]
df0 <- dim(models$mod0)[2]
cutoff <- qf(1e-04, df1-df0, n-df1, lower.tail=FALSE)
regs <- calculatePvalues(coveragePrep=prep, models=models, fstats=fstats, nPermute=10, seeds=1:10, chr=paste0("chr", opt$chr), maxGap=1e5, cutoff=cutoff, mc.cores=opt$mcores, verbose=opt$verbose)

## calculatePValues
timeinfo <- c(timeinfo, list(Sys.time()))

## Save the output from calculatePvalues
save(regs, file=paste0("regs-", opt$chr, ".Rdata"))

## saveRegs
timeinfo <- c(timeinfo, list(Sys.time()))

## Annotate
if(opt$verbose) message("Annotating regions")
library("bumphunter")
annotation <- annotateNearest(regs$regions, "hg19")

## Annotate
timeinfo <- c(timeinfo, list(Sys.time()))

save(annotation, file=paste0("annotation-", opt$chr, ".Rdata"))

## saveAnnotation
timeinfo <- c(timeinfo, list(Sys.time()))


## Save timing information
timeinfo <- do.call(c, timeinfo)
names(timeinfo) <- c("init", "load", "setup", "saveStatsOpts", "buildModels", "saveModels", "prepData", "savePrep", "calculateStats", "saveStats", "calculatePvalues", "saveRegs", "annotate", "saveAnno")
save(timeinfo, file=paste0("timeinfo-", opt$chr, ".Rdata"))

if(opt$prof) {
	Rprof(NULL)
}

## Done
if(opt$verbose) {
	print(proc.time())
	print(sessionInfo(), locale=FALSE)
}
