Explanation of files
====================

# find_insert_size.sh

This shell script uses the steps described in http://molecularevolution.org/resources/activities/velvet_and_bowtie_activity to determine the insert sizes for the paired-end reads.

* It runs `bowtie2 `and creates the output file `check_size.sam`.
* Then it uses awk to parse the SAM file and creates `check_size.filt1.sam` and `check_size.filt.sam`.
* Next it runs the perl script `get_insert_sizes_from_sam.pl` written by Matthew Conte that generates the file `check_sizes.sizes`.
* Finally it runs the R script `find_insert_size.R` that finds some simple summary statistics and generates `sizes_hist.pdf` and `sizes_box.pdf`.

# runth.sh

This shell script runs `TopHat` on the single-end files. It creates several hidden shell scripts that are then submitted to the cluster.

# runth_paired.sh

This shell script runs TopHat on the paired-end files using the insert size information obtained earlier. It creates several hidden shell scripts that are then submitted to the cluster.

# makeBai.sh

This simple shell script uses SAMtools to generate the BAM file indexes for the alignment files.
