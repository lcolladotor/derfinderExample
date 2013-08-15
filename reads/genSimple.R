# Script to generate files_simple.txt

# Read files info
yri <- read.table("files_yri.txt", header=TRUE, sep="\t")
ceu.fem <- read.table("files_ceu.txt", header=TRUE, sep="\t")
ceu.male <- read.table("files_ceu_male.txt", header=TRUE, sep="\t")
ceu.more <- read.table("files_ceu_more.txt", header=TRUE, sep="\t")

extract <- function(df, example, gender, pop) { 
	res <- df[, c("run", "file.name", "library.layout")]
	for(i in 1:ncol(res)) res[, i] <- as.character(res[, i])
	res$hapmap.id <- unlist(lapply(strsplit(as.character(df$library.name), "_"), function(x) { x[1]}))
	res$example <- rep(example, nrow(res))
	res$gender <- rep(gender, nrow(res))
	res$pop <- rep(pop, nrow(res))
	return(res)
}

# Construct the table
simple <- extract(yri, 1, "female", "YRI")
simple <- rbind(simple, extract(ceu.fem, 1, "female", "CEU"))
simple <- rbind(simple, extract(ceu.fem, 2, "female", "CEU")) # Same as above except for the "example"
simple <- rbind(simple, extract(ceu.male, 2, "male", "CEU"))
simple <- rbind(simple, extract(ceu.fem, 3, "female", "CEU")) # Third time it appears, except example is 3 now
simple <- rbind(simple, extract(ceu.more, 3, "female", "CEU"))
simple

# Write files_simple.txt
write.table(simple, file="files_simple.txt", quote=FALSE, row.names=FALSE, sep="\t")

## Examples on how to use it:

# Read it:
simple <- read.table("files_simple.txt", header=TRUE, sep="\t", stringsAsFactors=FALSE)

# Get the entries for the 2nd data set
subset(simple, example==2)

# Create lists of comma-separated file names for each paired-end pair
tmp <- subset(simple, example=="2")
tapply(tmp$file.name, tmp$run, function(x) { paste(x, collapse=",")})


##### For paired-end files
paired <- subset(simple, pop == "CEU" & !duplicated(file.name) )
paired

x <- tapply(paired$file.name, paired$run, function(x) matrix(x, ncol=2))
df <- as.data.frame(do.call("rbind", x), stringsAsFactors=FALSE)
colnames(df) <- c("file.name.1", "file.name.2")
df$run <- names(x)
write.table(df, file = "paired.txt", quote=FALSE, sep="\t", row.names=FALSE, col.names = FALSE)