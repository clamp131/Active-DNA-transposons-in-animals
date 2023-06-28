#!/usr/bin/perl -w
use strict;

my %all=();
my $name='';
open FILE,"list.fas";
chomp (my @a=<FILE>);
close FILE;
for(my $i=0;$i<=$#a;$i+=2){
    my $name=substr($a[$i],1,);
    $all{$name}=$a[$i+1];
}

open FILE, "list";
chomp (@a=<FILE>);
close FILE;

for(my $i=0;$i<=$#a;$i+=1){
    my @line1=split/\t/,$a[$i];
    my $tag=$line1[2];
    open TEMP,">temp.fas";
    print TEMP ">$line1[1]\n$all{$line1[0]}\n";
    close TEMP;
    
    my $file1=$line1[0].".rm";  #output the repeatmasker result
    my $file2=$tag.".fa";       #the genome sequence file
    my $out1=$line1[0].'.fk1.fas';
    my $out3=$line1[0].'.fk2.fas';
    my $out2=$line1[0].'.fas';
    
    `RepeatMasker -pa 30 -nolow -norna -lib temp.fas $file2`;  #re-annotate the genome using the sequence of each DNA TE
    open FILE1,"$file2.out";
    open OUT,">$file1";
    while(<FILE1>){
        print OUT " $_";
    }
    close OUT;
    close FILE1;
    
    print "$file1\t$file2\n";
    
    my %count=();
    open FILE2,"$file1";
    while(<FILE2>){
	$_=~s/[\(\)]//g;
	my @line=split/\s+/,$_;
	if(defined $line[10] && $line[10] eq $line1[1]){
	    my $id=$line[5].','.$line[6].','.$line[7];
	    $count{$line[5]}{$line[6]}{chr}=$line[5];
	    $count{$line[5]}{$line[6]}{start}=$line[6];
	    $count{$line[5]}{$line[6]}{end}=$line[7];
	    $count{$line[5]}{$line[6]}{strand}=$line[9];
	    $count{$line[5]}{$line[6]}{name}=$line[10];
	    $count{$line[5]}{$line[6]}{class}=$line[11];
	    $count{$line[5]}{$line[6]}{family}=$line[11];
	    $count{$line[5]}{$line[6]}{r_start}=$line[12];
	    $count{$line[5]}{$line[6]}{r_end}=$line[13];
	    $count{$line[5]}{$line[6]}{r_left}=$line[14];
	    $count{$line[5]}{$line[6]}{div}=$line[2];
	    if($line[9] eq 'C'){
		$count{$line[5]}{$line[6]}{r_start}=$line[14];
		$count{$line[5]}{$line[6]}{r_left}=$line[12];
	    }
	}
	
    }
    close FILE2;
    
    open FILE3,"$file2";
    my %fas=();
    my $name='';
    while(<FILE3>){
	chomp $_;
	if($_=~/^>/){
	    my @line=split/\s+/,$_;
	    $name=substr($line[0],1,);
	}else{
	    $fas{$name}.=$_;
	}
    }
    close FILE3;
    
    open OUT,">$out1";
    open OUT1,">$out2";
    open OUT2,">$out3";
    for my $chr(sort keys %count){
	LINE1:for my $start1(sort {$a <=> $b} keys %{$count{$chr}}){
	    if($count{$chr}{$start1}{r_start} ==1 && $count{$chr}{$start1}{r_left} ==0){   # the auto TE copies
            my $fas=substr($fas{$count{$chr}{$start1}{chr}},$count{$chr}{$start1}{start}-1,$count{$chr}{$start1}{end}-$count{$chr}{$start1}{start}+1);
            my $fas1=substr($fas{$count{$chr}{$start1}{chr}},$count{$chr}{$start1}{start}-101,100);  #the 5' flanking sequence
            my $fas2=substr($fas{$count{$chr}{$start1}{chr}},$count{$chr}{$start1}{end},100);  #the 3' flanking sequence
            if($count{$chr}{$start1}{strand} eq "C"){
                $fas=~tr/ATCGatcg/TAGCtagc/;
                $fas=reverse $fas;
                $fas1=~tr/ATCGatcg/TAGCtagc/;
                $fas1=reverse $fas1;
                $fas2=~tr/ATCGatcg/TAGCtagc/;
                $fas2=reverse $fas2;
            }
            print OUT1 ">auto,$chr,$start1,$count{$chr}{$start1}{end},$chr,$start1,$count{$chr}{$start1}{end},$count{$chr}{$start1}{strand},$count{$chr}{$start1}{div}\n$fas\n";
            print OUT ">auto,$chr,$start1,$count{$chr}{$start1}{end},$chr,$start1,$count{$chr}{$start1}{end},$count{$chr}{$start1}{strand}\n$fas1\n";
            print OUT2 ">auto,$chr,$start1,$count{$chr}{$start1}{end},$chr,$start1,$count{$chr}{$start1}{end},$count{$chr}{$start1}{strand}\n$fas2\n";
            next LINE1;
	    }else{    #search for MITEs
		LINE:for my $start2(sort {$a <=> $b} keys %{$count{$chr}}){
		    if($start1 < $start2 && $count{$chr}{$start2}{start}-$count{$chr}{$start1}{end}<=$line1[3] && $count{$chr}{$start2}{start}-$count{$chr}{$start1}{end}>=-$line1[3]){  # two fragments of TE, and their distance is short than the full length of consensus TE
                if($count{$chr}{$start1}{strand} eq $count{$chr}{$start2}{strand} && $count{$chr}{$start1}{name} eq $count{$chr}{$start2}{name}){  # the TE fragments belong to the same type and direction
                    if($count{$chr}{$start1}{strand} eq "+"){
                        if($count{$chr}{$start1}{r_start} ==1 && $count{$chr}{$start2}{r_left} ==0 && $count{$chr}{$start2}{r_start}-$count{$chr}{$start1}{r_end}>=0){  # the TE fragments have perfect terminals
                            #my $fas=substr($fas{$count{$chr}{$start1}{chr}},$count{$chr}{$start1}{start}-1,$count{$chr}{$start2}{end}-$count{$chr}{$start1}{start}+1);
                            my $fas=substr($fas{$count{$chr}{$start1}{chr}},$count{$chr}{$start1}{start}-1,$count{$chr}{$start1}{end}-$count{$chr}{$start1}{start}+1).substr($fas{$count{$chr}{$start1}{chr}},$count{$chr}{$start2}{start}-1,$count{$chr}{$start2}{end}-$count{$chr}{$start2}{start}+1);
                            my $fas1=substr($fas{$count{$chr}{$start1}{chr}},$count{$chr}{$start1}{start}-101,100);
                            my $fas2=substr($fas{$count{$chr}{$start1}{chr}},$count{$chr}{$start2}{end},100);
                            my $n_rep=$fas;
                            $n_rep=~ s/N//g;
                            if(length($n_rep)>=10 && length($n_rep)/length($fas)>=0.8){  #the gap in genome should not exceed 20% of total length of MITEs
                            print OUT1 ">mite,$chr,$start1,$count{$chr}{$start1}{end},$chr,$start2,$count{$chr}{$start2}{end},$count{$chr}{$start2}{strand},$count{$chr}{$start1}{div};$count{$chr}{$start2}{div};\n$fas\n";  #output the position of TE copies and the divergence values
                            print OUT ">mite,$chr,$start1,$count{$chr}{$start1}{end},$chr,$start2,$count{$chr}{$start2}{end},$count{$chr}{$start2}{strand}\n$fas1\n";
                            print OUT2 ">mite,$chr,$start1,$count{$chr}{$start1}{end},$chr,$start2,$count{$chr}{$start2}{end},$count{$chr}{$start2}{strand}\n$fas2\n";
                            #print OUT "$count{$chr}{$start1}{chr}\t$count{$chr}{$start1}{start}\t$count{$chr}{$start1}{end}\t$count{$chr}{$start1}{strand}\t$count{$chr}{$start1}{name}\t$count{$chr}{$start1}{class}\t$count{$chr}{$start1}{family}\t$count{$chr}{$start1}{r_start}\t$count{$chr}{$start1}{r_end}\t$count{$chr}{$start1}{r_left}\t";
                            #print OUT "$count{$chr}{$start2}{chr}\t$count{$chr}{$start2}{start}\t$count{$chr}{$start2}{end}\t$count{$chr}{$start2}{strand}\t$count{$chr}{$start2}{name}\t$count{$chr}{$start2}{class}\t$count{$chr}{$start2}{family}\t$count{$chr}{$start2}{r_start}\t$count{$chr}{$start2}{r_end}\t$count{$chr}{$start2}{r_left}\n";
                            }
                        }
                    }else{
                        if($count{$chr}{$start1}{r_left} ==0 && $count{$chr}{$start2}{r_start} ==1 && $count{$chr}{$start1}{r_start}-$count{$chr}{$start2}{r_end}>=0){
                            #my $fas=substr($fas{$count{$chr}{$start1}{chr}},$count{$chr}{$start1}{start}-1,$count{$chr}{$start2}{end}-$count{$chr}{$start1}{start}+1);
                            my $fas=substr($fas{$count{$chr}{$start1}{chr}},$count{$chr}{$start1}{start}-1,$count{$chr}{$start1}{end}-$count{$chr}{$start1}{start}+1).substr($fas{$count{$chr}{$start1}{chr}},$count{$chr}{$start2}{start}-1,$count{$chr}{$start2}{end}-$count{$chr}{$start2}{start}+1);
                            $fas=~tr/ATCGatcg/TAGCtagc/;
                            $fas=reverse $fas;
                            my $fas1=substr($fas{$count{$chr}{$start1}{chr}},$count{$chr}{$start1}{start}-101,100);
                            my $fas2=substr($fas{$count{$chr}{$start1}{chr}},$count{$chr}{$start2}{end},100);
                            $fas1=~tr/ATCGatcg/TAGCtagc/;
                            $fas1=reverse $fas1;
                            $fas2=~tr/ATCGatcg/TAGCtagc/;
                            $fas2=reverse $fas1;
                            my $n_rep=$fas;
                            $n_rep=~ s/N//g;
                            if(length($n_rep)>=10 && length($n_rep)/length($fas)>=0.8){
                            print OUT1 ">mite,$chr,$start1,$count{$chr}{$start1}{end},$chr,$start2,$count{$chr}{$start2}{end},$count{$chr}{$start2}{strand},$count{$chr}{$start1}{div};$count{$chr}{$start2}{div};\n$fas\n";
                            print OUT ">mite,$chr,$start1,$count{$chr}{$start1}{end},$chr,$start2,$count{$chr}{$start2}{end},$count{$chr}{$start2}{strand}\n$fas1\n";
                            print OUT2 ">mite,$chr,$start1,$count{$chr}{$start1}{end},$chr,$start2,$count{$chr}{$start2}{end},$count{$chr}{$start2}{strand}\n$fas2\n";
                            #print OUT "$count{$chr}{$start1}{chr}\t$count{$chr}{$start1}{start}\t$count{$chr}{$start1}{end}\t$count{$chr}{$start1}{strand}\t$count{$chr}{$start1}{name}\t$count{$chr}{$start1}{class}\t$count{$chr}{$start1}{family}\t$count{$chr}{$start1}{r_start}\t$count{$chr}{$start1}{r_end}\t$count{$chr}{$start1}{r_left}\t";
                            #print OUT "$count{$chr}{$start2}{chr}\t$count{$chr}{$start2}{start}\t$count{$chr}{$start2}{end}\t$count{$chr}{$start2}{strand}\t$count{$chr}{$start2}{name}\t$count{$chr}{$start2}{class}\t$count{$chr}{$start2}{family}\t$count{$chr}{$start2}{r_start}\t$count{$chr}{$start2}{r_end}\t$count{$chr}{$start2}{r_left}\n";
                            }
                        }
                    }
                }
		    }elsif($count{$chr}{$start2}{start}-$count{$chr}{$start1}{end}>$line1[3]){
                last LINE;
		    }
		}
	    }
	} 
    }
    close OUT;
    close OUT1;

}
