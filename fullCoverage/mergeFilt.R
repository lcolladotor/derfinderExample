## Merge the filtered coverage data

library(IRanges)

## setup
chrnums <- c(1:22, "X", "Y")
filteredCov <- vector("list", 24)
names(filteredCov) <- chrnums

## Actual processing
for(chrnum in chrnums) {
	load(paste0("../derCoverageInfo/chr", chrnum, "CovInfo.Rdata"))
	eval(parse(text=paste0("data <- ", "chr", chrnum, "CovInfo")))
	filteredCov[[chrnum]] <- data
}

save(filteredCov, file="../derCoverageInfo/filteredCov.Rdata")
