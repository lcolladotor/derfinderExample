# Load library
library(SRAdb)

# Update sql if necessary:
sra.meta <- "~/sra/SRAmetadb.sqlite" # Using the file from another location to avoid having copies of this 2.4 Gb file
if(file.exists(sra.meta)) {
	sqlfile <- sra.meta
} else {
	sqlfile <- getSRAdbFile()
}

# Create connection
sra_con <- dbConnect(SQLite(),sqlfile)

# load files data
load("sraData.Rdata")

# write file information into text
write.table(files.ceu.male, "files_ceu_male.txt", quote = FALSE, row.names = FALSE, sep="\t")
write.table(files.ceu.more, "files_ceu_more.txt", quote = FALSE, row.names = FALSE, sep="\t")

# Get the fastq files
run <- c(files.ceu.male$run, files.ceu.more$run)
ascpCMD <- 'ascp -QT -l 300m -i ~/.aspera/connect/etc/asperaweb_id_dsa.putty'
getSRAfile(in_acc = run, sra_con, fileType = 'fastq', srcType = 'fasp', ascpCMD = ascpCMD)


# Disconnect from the db
dbDisconnect(sra_con)