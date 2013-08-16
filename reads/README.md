Explanation of files
====================

This folder has all the files related to choosing which samples to download.

# findData.R

This R script uses __SRAdb__ to search SRA and ENA for the information related to studies SRP001540 and ERP000101. It then chooses the samples used for this example and saves the information in `sraData.Rdata`

# getdata.R

This R script uses __SRAdb__ and `sraData.Rdata` to download the YRI and CEU samples. It then creates `files_yri.txt` and `files_ceu.txt` and then downloads the actual reads.

The shell script `getdata.sh` is just a helper script to run `getdata.R`.

# getdata_part2.R

This R script is very similar to `getdata.R`. It creates the files `files_ceu_male.txt` and `files_ceu_more.txt` and downloads the associated reads. 

The shell script `getdata_part2.sh` is a helper script.

# genSimple.R

This R script merges the other `files_*.txt` files and simplifies them. It then generates `files_simple.txt` and `paired.txt`. It also contains some examples on how to use this information.
