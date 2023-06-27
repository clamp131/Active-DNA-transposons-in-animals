#!/usr/bin/perl -w
use strict;
#print the species,family,name,length,number,median diversity;
my %all=();
open FILE1,"animal_list";
while(<FILE1>){
    chomp $_;
    my @line1=split/\t/,$_;
    chdir "$line1[1]";
    for my $file(glob "*.rmsk.fl"){ #open full length DNA TE dataset;
        open FILE,"$file";
        while(<FILE>){
	    my @line=split/\t/,$_;
	    $all{$line[0]}{$line[13]}{$line[11]}{n}++; #number	
	    $all{$line[0]}{$line[13]}{$line[11]}{l}=$line[15];	#length
	    $all{$line[0]}{$line[13]}{$line[11]}{d}.=$line[3].","; #diversity
        }
        close FILE;
        chdir "..";
    }
}
open OUT,">out";
for my $species(sort keys %all){
    for my $family(sort keys %{$all{$species}}){
	for my $name(sort keys %{$all{$species}{$family}}){
	    
	    #the median value of diversity
	    my @lst=split/,/,$all{$species}{$family}{$name}{d};
	    @lst=sort{$a <=> $b} @lst;
	    my $n=scalar @lst;
	    my $med=0;
	    if($n%2==0){
		my $num1=$lst[$n/2-1];
		my $num2=$lst[$n/2];
		$med=($num1+$num2)/2;
	    }else{ #the list has an odd number of values
		$med=$lst[($n-1)/2];
	    }
	    $med=$med/1000;
	    #################################
	    
	    print OUT "$species\t$family\t$name\t$all{$species}{$family}{$name}{l}\t$all{$species}{$family}{$name}{n}\t$med\n"; 
	}
	
    }
}
close OUT;
