## Run derfinder's analysis steps with timing info

## Load libraries
library("getopt")

## Available at https://github.com/lcolladotor/derfinder
library("derfinder")

## Specify parameters
spec <- matrix(c(
	'DFfile', 'd', 1, "character", "path to the .Rdata file with the results from loadCoverage()",
	'chr', 'c', 1, "character", "Chromosome under analysis. Use X instead of chrX.",
	'mcores', 'm', 1, "integer", "Number of cores",
	'verbose' , 'v', 2, "logical", "Print status updates",
	'prof', 'p', 2, "logical", "Run Rprof()",
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
	opt$DFfile <- "/dcl01/lieber/ajaffe/derRuns/derfinderExample/derCoverageInfo/chr21CovInfo.Rdata"
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


if(opt$verbose) message("Loading Rdata file with the output from loadCoverage()")
load(opt$DFfile)

## Make it easy to use the name later. Here I'm assuming the names were generated using output='auto' in loadCoverage()
eval(parse(text=paste0("data <- ", "chr", opt$chr, "CovInfo")))

## Just for testing purposes
if(test) {
	tmp <- data
	tmp$coverage <- tmp$coverage[1:1e6, ]
	library("IRanges")
	tmp$position[which(tmp$pos)[1e6 + 1]:length(tmp$pos)] <- FALSE
	data <- tmp
}

## Load the models
load("models.Rdata")

## Load group information
load("groupInfo.Rdata")

## Run the analysis
analyzeChr(chrnum=opt$chr, coverageInfo=data, models=models, cutoffFstat=1e-05, cutoffType="theoretical", nPermute=10, maxClusterGap=3000, groupInfo=groupInfo, subject="hg19", mc.cores=opt$mcores, verbose=opt$verbose)


if(opt$prof) {
	Rprof(NULL)
}

## Done
if(opt$verbose) {
	print(proc.time())
	print(sessionInfo(), locale=FALSE)
}
