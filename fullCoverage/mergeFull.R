## Merge the coverage data

library(IRanges)

## setup
chrnums <- c(1:22, "X", "Y")
fullCov <- vector("list", 24)
names(fullCov) <- chrnums

## Actual processing
for(chrnum in chrnums) {
	load(paste0("chr", chrnum, "CovInfo.Rdata"))
	eval(parse(text=paste0("data <- ", "chr", chrnum, "CovInfo")))
	fullCov[[chrnum]] <- data$coverage
}

save(fullCov, file="../derCoverageInfo/fullCov.Rdata")
