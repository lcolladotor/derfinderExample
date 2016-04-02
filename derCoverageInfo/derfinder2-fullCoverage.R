## Load the data without a filter, save it, then filter it for derfinder2 processing steps

## Load libraries
library("getopt")

## Available at https://github.com/lcolladotor/derfinder
library("derfinder")
library("parallel")

## Specify parameters
spec <- matrix(c(
	'datadir', 'd', 1, "character", "Data directory, matched with makeBamList(datadir)",
	'pattern', 'p', 1, "character", "Sample pattern",
	'cutoff', 'c', 1, "integer", "Filtering cutoff used",
	'mcores', 'm', 1, "integer", "Number of cores",
	'number', 'n', 1, "logical", "Whether to use chr numbers (say 5) or chr names (say chr5). Depends on how the chromosomes are named in the BAM files.",
	'verbose' , 'v', 2, "logical", "Print status updates",
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
	opt$datadir <- "/dcl01/lieber/ajaffe/derRuns/derfinderExample/thout"
	opt$pattern <- "RR"
	opt$cutoff <- 5
	opt$mcores <- 1
	opt$number <- TRUE
	opt$verbose <- NULL
}

## if help was asked for print a friendly message
## and exit with a non-zero error code
if (!is.null(opt$help)) {
	cat(getopt(spec, usage=TRUE))
	q(status=1)
}

## Default value for verbose = TRUE
if (is.null(opt$verbose)) opt$verbose <- TRUE

## Identify the data directories
## You might have to change the 'bamterm' argument depending on how you organized your data
dirs <- makeBamList(datadir=opt$datadir, samplepatt=opt$pattern)

## In some cases, you might want to modify the names of the dirs object
## These names specify the column names used in the DataFrame objects.
## For example, they could end with _out
# names(dirs) <- gsub('_out', '', names(dirs))

## Load the coverage information without filtering
chrnums <- c(1:22, 'X', 'Y')
names(chrnums) <- chrnums
if(!opt$number){
	use.chr <- paste0("chr", chrnums)
} else {
	use.chr <- chrnums
}
fullCov <- fullCoverage(dirs=dirs, chrnums=use.chr, mc.cores=opt$mcores, verbose=opt$verbose)

if(opt$verbose) message(paste(Sys.time(), "Saving the full (unfiltered) coverage data"))
## Needed for some data sets as derfinder2 assumes no names start with chr
if(!opt$number){
	names(fullCov) <- gsub("chr", "", names(fullCov)) ## Not needed in this specific example
}
save(fullCov, file="fullCov.Rdata")

## Filter the data and save it by chr
myFilt <- function(chrnum) {
	## Filter the data
	res <- filterData(data=fullCov[[chrnum]], cutoff=opt$cutoff, index=NULL, colnames=names(dirs), verbose=opt$verbose)
	
	## Save it in a unified name format
	varname <- paste0("chr", chrnum, "CovInfo")
	assign(varname, res)
	output <- paste0(varname, ".Rdata")
	
	## Save the DataFrame
	save(list=varname, file=output, compress="gzip")
	
	## Finish
	return(res)
}

if(opt$verbose) message(paste(Sys.time(), "Filtering and saving the data"))
filteredCov <- mclapply(names(chrnums), myFilt, mc.cores=opt$mcores)
## This is needed for sampleDepth()
save(filteredCov, file="filteredCov.Rdata")

## Done!
proc.time()
sessionInfo()
