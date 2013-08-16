#### Merge the results from derfinder2's analysis

## Load libraries
library("getopt")
library("IRanges")
library("GenomicRanges")

## Specify parameters
spec <- matrix(c(
	'prefix', 'p', 2, "character", "Prefix for the output files.",
	'help' , 'h', 0, "logical", "Display help"
), byrow=TRUE, ncol=5)
opt <- getopt(spec)

## if help was asked for print a friendly message
## and exit with a non-zero error code
if (!is.null(opt$help)) {
	cat(getopt(spec, usage=TRUE))
	q(status=1)
}

## Default value for prefix
if (is.null(opt$prefix)) opt$prefix <- ""


## setup
chrs <- c(1:22, "X", "Y")
fullTime <- fullNullwidths <- fullNullstats <- fullFstats <- fullAnno <- fullRegs <- vector("list", 24)
names(fullTime) <- names(fullNullwidths) <- names(fullNullstats) <- names(fullFstats) <- names(fullAnno) <- names(fullRegs) <- chrs

## Actual processing
for(chr in chrs) {
	message(paste(Sys.time(), "Loading chromosome", chr))
	
	## Process the F-statistics
	load(paste0(opt$prefix, "chr", chr, "/fstats-", chr, ".Rdata"))
	fullFstats[[chr]] <- fstats
	
	## Process the regions, nullstats and nullwidths
	load(paste0(opt$prefix, "chr", chr, "/regs-", chr, ".Rdata"))
	fullRegs[[chr]] <- regs$regions
	fullNullstats[[chr]] <- regs$nullstats
	fullNullwidths[[chr]] <- regs$nullwidths
	
	## Process the annotation results
	load(paste0(opt$prefix, "chr", chr, "/annotation-", chr, ".Rdata"))
	annotation$chr <- rep(chr, nrow(annotation))
	fullAnno[[chr]] <- annotation
	
	## Process the timing information
	load(paste0(opt$prefix, "chr", chr, "/timeinfo-", chr, ".Rdata"))
	fullTime[[chr]] <- timeinfo
}

## Save Fstats, Nullstats, and time info
message(paste(Sys.time(), "Saving fullFstats"))
save(fullFstats, file=paste0(opt$prefix, "fullFstats.Rdata"))
message(paste(Sys.time(), "Saving fullTime"))
save(fullTime, file=paste0(opt$prefix, "fullTime.Rdata"))
message(paste(Sys.time(), "Saving fullNullstats"))
save(fullNullstats, file=paste0(opt$prefix, "fullNullstats.Rdata"))
message(paste(Sys.time(), "Saving fullNullwidths"))
save(fullNullwidths, file=paste0(opt$prefix, "fullNullwidths.Rdata"))

## Save the annotation 
fullAnnotation <- do.call(rbind, fullAnno)
rownames(fullAnnotation) <- seq_len(nrow(fullAnnotation))

## Combine regions with annotation
fullRegionsDF <- unlist(GRangesList(fullRegs), use.names=FALSE)

## Check
identical(length(fullRegionsDF), dim(fullAnnotation)[1])

## save DF version
message(paste(Sys.time(), "Saving fullAnnotation"))
save(fullAnnotation, file=paste0(opt$prefix, "fullAnnotation.Rdata"))
message(paste(Sys.time(), "Saving fullRegionsDF"))
save(fullRegionsDF, file=paste0(opt$prefix, "fullRegionsDF.Rdata"))

## Transform fullRegionsDF to a regular data.frame
names(fullRegionsDF) <- seq_len(length(fullRegionsDF))
fullRegions <- as.data.frame(fullRegionsDF)
colnames(fullRegions)[1] <- "chr"
colnames(fullRegions)[4] <- "L"

## Re-order columns to match the output form regionFinder() in bumphunter
fullRegions <- fullRegions[, c("chr", "start", "end", "value", "area", "cluster", "indexStart", "indexEnd", "L", "clusterL", "pvalues", "qvalues", "significant", "significantQval")]

## save data.frame version
message(paste(Sys.time(), "Saving fullRegions"))
save(fullRegions, file=paste0(opt$prefix, "fullRegions.Rdata"))


## save a huge data frame with the information merged
fullRegsAnno <- cbind(fullRegions, fullAnnotation)
colnames(fullRegsAnno)[ncol(fullRegsAnno)] <- "chrnum"

message(paste(Sys.time(), "Saving fullRegsAnno"))
save(fullRegsAnno, file=paste0(opt$prefix, "fullRegsAnno.Rdata"))

print(proc.time())
sessionInfo()
