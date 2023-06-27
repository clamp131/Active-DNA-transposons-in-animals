#!/usr/bin/perl -w
use strict;
#search for the full length DNA TEs;
my $tot=0;
open FILE1,"animal_list"; #list in folder 'reference_genomes'
while(<FILE1>){
    chomp $_;
    my @line=split/\t/,$_;
    chdir "$line[1]";  #enter the folder containing the genome and repeatmasker files
    my $file=$_.'.rmsk'; #be sure the file name starts with the assembly name
    open FILE,"$file";
    open OUT,">$file.fl";
    my $name=substr($file,0,index($file,'.'));
    while(<FILE>){
	$_=~s/[\(\)]//g;
	my @line=split/\t/,$_;
	if($line[11] =~ 'DNA'){
	    if(abs($line[13])<=1 && abs($line[15])<=1){ #start and end is correct;
		#if(($line[7]-$line[6]+1)/($line[14]-abs($line[13])+1)<0.5){
		if(($line[7]-$line[6]+1)/($line[14]-abs($line[13])+1)>0.9){
		    #$tot++;
			print OUT "$name\t$_";
		}
	    }
	}
    }
    close FILE;
    close OUT;
    chdir "..";
}
close FILE1;
#print "$tot\n";
