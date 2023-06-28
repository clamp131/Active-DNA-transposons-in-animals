#!/usr/bin/perl -w
use strict;

open OUT,">filter_tnp";
for my $file(glob "cavefish-families.fas.orf.pf"){
    open FILE,"$file";
    while(<FILE>){
    	  chomp $_;
    	  if($_=~/^lcl/){
    	      my @line=split/\s+/,$_;
    	      my @line1=split/:/,$line[0];
    	      if(($line[6]=~/tnp/ || $line[6]=~/Tnp/ || $line[6]=~/Transposase/ || $line[6]=~/MULE/ || $line[6]=~/Myb/ || $line[6]=~/DDE/ || $line[6]=~/SWIM/)){
    		        print OUT "$line[0]\t$line[5]\t$line[6]\n";
    	      }
    	  }
    }
    close FILE;
}
close OUT;
