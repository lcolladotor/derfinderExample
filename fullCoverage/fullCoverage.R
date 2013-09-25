### Helper script for loading the data

## Load the coverage information without 
fullCov <- fullCoverage(dirs=dirs, chrnums=c(1:22, 'X', 'Y'), mc.cores=cores, verbose=TRUE)

message(paste(Sys.time(), "Saving the full (unfiltered) coverage data"))
## Needed for some data sets as derfinder2 assumes no names start with chr, but might be changed
## names(fullCov) <- gsub("chr", "", names(fullCov)) ## Not needed in this specific example
save(fullCov, file="fullCov.Rdata")

## Filter the data and save it by chr
myFilt <- function(x) {
	## Filter the data
	res <- filterData(data=x, cutoff=5, index=NULL, colnames=names(dirs), verbose=TRUE)
	
	## Save it in a unified name format
	varname <- paste0(chr, "CovInfo")
	assign(varname, res)
	output <- paste0(varname, ".Rdata")
	
	## Save the DataFrame
	save(list=varname, file=file.path("..", "derCoverageInfo", output), compress="gzip")
	
	## Finish
	return(res)
}

message(paste(Sys.time(), "Filtering and saving the data"))
library("parallel")
covList <- mclapply(fullCov, myFilt, mc.cores=cores)

## Done!
proc.time()
sessionInfo()
