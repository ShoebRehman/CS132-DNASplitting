#!/usr/bin/env perl
#
# DNA Transcription -- receives a file as a command line argument and translates the DNA to RNA then transcribes the RNA into One-Letter Amino Acid sequences
#
# Written by: Shoeb Rehman
#             12/1/2014
#
# Usage Information: Run the script along with 2 files (an enzyme file and a DNA file)
#-------------------------------------------------------------------------------
#                    Assignment 7: DNA -> RNA -> Amino Acid Conversion
#-------------------------------------------------------------------------------

$^W = 1; # Turns Warnings On
use strict;

my (@dna, @enzyme);


#Opens Enzyme file (1st arguent)
open (FILE, "@ARGV[0]") or die "Unable to open @ARGV[0]";
@enzyme = <FILE>;

close FILE;

open (DNAFILE, "@ARGV[1]") or die "Unable to open @ARGV[1]";

@dna = <DNAFILE>;
close DNAFILE;

my $dna_file;
chomp(@dna);
$dna_file = join('',@dna);


# Cleans the spaces in the file
$dna_file =~ s/ //g;

if($dna_file =~ /([^ACGT])/i){ #checks to see if there are any non-valid characters in file
        print "This file contains a non-valid letter.\n Now terminating... \n";
        exit;
}

#Open the Enzyme file, from each line extract the name, the pattern of the enzyme and the distance from the start to the cleavage site

my ($distance, $temp_dna);
my %enzyme_hash = ();

foreach my $loop_enzyme (@enzyme) {
        my @test_enzyme = split (/\//, $loop_enzyme); #splitting the pattern to save the recognition enzyme and sequence
        my @recognition = split (/'/,$test_enzyme[1]);
        $distance = length($recognition[0]);
        my $seq = join('',@recognition);

        $enzyme_hash {$test_enzyme[0]} {seq} = $seq;
        $enzyme_hash {$test_enzyme[0]} {distance} = $distance;
}

for my $each_enzyme (keys %enzyme_hash) {
        my ($filename, $seq, $distance);

        # Create input file with the proper name
        $filename = $ARGV[1] . "_" . $each_enzyme;

        # Open the file to write
        open (OUTPUT, ">$filename") or die "Unable to open $filename. \n";
        $seq = $enzyme_hash {$each_enzyme} {seq};
        $distance = $enzyme_hash {$each_enzyme} {distance};

        #searches for the sequence in the DNA file
        while ($dna_file =~ /$seq/i) {
                my $before_cut = $` . substr($&, 0, $distance); #when found, cuts it
                $dna_file = substr($&, $distance) . $' ;#remainder of sequence is saved
                print OUTPUT "$before_cut\n"; #outputs it onto the file
        }
        print OUTPUT "$dna_file\n";
}
       
