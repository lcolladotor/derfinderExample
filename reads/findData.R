# Load library
library(SRAdb)

# Update sql if necessary:
sra.meta <- "~/enigma2/sra/SRAmetadb.sqlite" # Using the file from another location to avoid having copies of this 2.4 Gb file
if(file.exists(sra.meta)) {
	sqlfile <- sra.meta
} else {
	sqlfile <- getSRAdbFile()
}

# Create connection
sra_con <- dbConnect(SQLite(),sqlfile)

# Define the SRA study accession id's of interest
study <- c("SRP001540", "ERP000101")

# Search for them in SRA
search.res <- dbGetQuery(sra_con, paste("select * from study where study_accession in ('", paste(study, collapse="', '"), "')", sep = ""))
# Find the files (through ENA)
files <- listSRAfile( in_acc = study, sra_con = sra_con, fileType="fastq", srcType='fasp')

# Some exploration
table(files$study)

# Downloaded hapmap information files to /info
# from http://hapmap.ncbi.nlm.nih.gov/downloads/samples_individuals/
relation <- read.table("info/relationships_w_pops_121708.txt", header=TRUE)

# only looking for females which is coded as sex = 2
yri <- subset(relation, population == "YRI" & sex == 2 & mom == 0)
ceu <- subset(relation, population == "CEU" & sex == 2 & mom == 0)

# I set mom == 0 because I'm looking for unrelated samples, and 0 means that it's a founder.
# I'm assuming all "founders" (parents in trios) are unrelated, but can still check with
max(table(yri$FID))
max(table(ceu$FID)) # hm... 2

# I'm keeping only the first element of a same FID (family id)
ceu <- ceu[!duplicated(ceu$FID), ]


###### For data set 1
# Randomly permute the sample ids
set.seed(101)
mom.yri <- as.character(sample(yri$IID))
set.seed(102)
mom.ceu <- as.character(sample(ceu$IID))

# Obtain ids from the ENA information
iids <- unlist(lapply(strsplit(files$library.name, "_"), function(x) { x[1]}))

# choose.id finds the first 5 ids that have fastq files
choose.id <- function(df, find.id, iids, res, i = 1, j = 0 ) {
	current <- find.id[i]
	new <- files[iids %in% current, ]
	if(nrow(new) > 0) {
		res.new <- rbind(res, new)
		j <- j + 1
	} else{
		res.new <- res
	}
	i <- i + 1
	if(j < 5) {
		if(length(find.id) == i) {
			warning("Could not find 5 data sets within the ids given to search.")
			return(res.new)
		} else {
			choose.id(df, find.id, iids, res.new, i, j)
		}
	} else {
		return(res.new)
	}
}

# Find the files
files.yri <- NULL
files.yri <- choose.id(files, mom.yri, iids, files.yri)

files.ceu <- NULL
files.ceu <- choose.id(files, mom.ceu, iids, files.ceu)

###### For data set 2
# use the same females from files.ceu
# Next, find 5 unrelated males
ceu.male <- subset(relation, population == "CEU" & sex == 1 & dad == 0 & !(FID %in% ceu$FID[ ceu$IID %in% files.ceu$library.name]) )
ceu.male <- ceu.male[!duplicated(ceu.male$FID), ]

# find 5 males
set.seed(103)
dad.ceu <- as.character(sample(ceu.male$IID))
files.ceu.male <- NULL
files.ceu.male <- choose.id(files, dad.ceu, iids, files.ceu.male)

###### For data set 3

# Find 5 more unrelated samples from Montgomery
mom.ceu.more <- mom.ceu[! mom.ceu %in% files.ceu$library.name]
files.ceu.more <- NULL
files.ceu.more <- choose.id(files, mom.ceu.more, iids, files.ceu.more)

# Save file information
save(files, search.res, files.yri, files.ceu, files.ceu.male, files.ceu.more, file="sraData.Rdata")

# Disconnect from the db
dbDisconnect(sra_con)

