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
write.table(files.yri, "files_yri.txt", quote = FALSE, row.names = FALSE, sep="\t")
write.table(files.ceu, "files_ceu.txt", quote = FALSE, row.names = FALSE, sep="\t")

# Get the fastq files
run <- c(files.yri$run, files.ceu$run)
ascpCMD <- 'ascp -QT -l 300m -i ~/.aspera/connect/etc/asperaweb_id_dsa.putty'
getSRAfile(in_acc = run, sra_con, fileType = 'fastq', srcType = 'fasp', ascpCMD = ascpCMD)


# Disconnect from the db
dbDisconnect(sra_con)