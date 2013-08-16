## Merge the coverage data

library(IRanges)

## setup
chrs <- c(1:22, "X", "Y")
covList <- vector("list", 24)
names(covList) <- chrs

## Actual processing
for(chr in chrs) {
	load(paste0("chr", chr, "CovInfo.Rdata"))
	eval(parse(text=paste0("data <- ", "chr", chr, "CovInfo")))
	covList[[chr]] <- data
}

save(covList, file="covList.Rdata")
