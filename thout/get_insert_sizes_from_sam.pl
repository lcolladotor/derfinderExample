#!/usr/bin/perl
use strict;

# This scripts reads the Bowtie .aln output and determines the insert size from mapped mate-pair reads.
#
# usage: perl get_insert_sizes_from_bowtie_aln.pl <bowtie_output>
##
# @author - Matthew Conte

@ARGV == 1 or die "usage: perl get_insert_sizes_from_bowtie_aln.pl <bowtie_output>\n";
my $bowtie_output = @ARGV[0];

open (BOWTIE_OUTPUT, "< $bowtie_output") or die "Can't open $bowtie_output\n";

my $prev_seq_name;
my $prev_pos;
my $prev_base_name;
my $prev_lane;
my $prev_dir;
my $first_bool = 0;
my $count = 0;
my @diffs;

while (<BOWTIE_OUTPUT>) {
  next if (/^@/);
  my @line = split(/\t/, $_);
  die "not enough fields in line $_\n" if (@line < 11);
  my $seq_name = @line[0];
  my $pos = @line[3];
  my @tmp = split(/\//, $seq_name);
  my $base_name = @tmp[0];
  my $dir = @line[1];
  
  if ($dir eq $prev_dir){
    die "$_ read pairs were mapped in the same orientation, check on this\n";
  }

  #get the length of the sequence b/c we are going to add it to the difference since
  #bowtie reports the starts of both pairs in reference space, but velvet wants the
  #length of the sequenced fragment which includes the reads
  my $sequence = @line[9];
  my $seq_length = length($sequence);
  if ($base_name eq $prev_base_name) {
    $count++;
    my $diff;
    if ($prev_pos > $pos) {
      $diff = $prev_pos - $pos + $seq_length;
    } elsif ($pos > $prev_pos) {
      $diff = $pos - $prev_pos + $seq_length;
    } else {
      # die "something looks wrong with the positions of the mapped reads, $seq_name\n";
      # Modified this to completely ignore cases where the positions look "weird"
      # R will notice that this is a NA
      $diff = "";
    }
    push (@diffs, $diff);
  }
  $prev_base_name = $base_name;
  $prev_dir = $dir;
  #$prev_lane = $lane;
  $prev_pos = $pos;
  
}

for my $i (@diffs) {
  print "$i\n";
}
#print "@diffs\n";
#print "$count\n";
