#!/usr/bin/perl -w
use strict;

open FILE,"list.fas";
chomp (my @a=<FILE>);
close FILE;

open OUT, ">TIR.out";
for(my $i=0;$i<=$#a;$i+=2){
    my $name=substr($a[$i],1,);
    open OUT1, ">$name.con.fas";
    $a[$i+1]=~tr/ATCG/atcg/;
    my $seq=$a[$i+1];
    $seq=~tr/atcgATCG/tagctagc/;
    $seq=reverse $seq;
    print OUT1 ">L\n$a[$i+1]\n>R\n$seq\n"; #the complementary sequences of TE
    close OUT1;
    `mafft $name'.con.fas' >$name'.con.fasta'`; #align the complementary sequences

    open FILE,"$name.con.fasta";
    my %all=();
    my $name='';
    while (<FILE>) {
        chomp $_;
        if ($_=~/^>/) {
            $name=substr($_,1,);
        }else{
            $all{$name}.=$_;
        }
    }
    close FILE;
    
    my $count=0;
    my $pos=0;
    LINE:for (my $i=0;$i<=length($all{'L'});$i++){
        my $base1=substr($all{'L'},$i,1);
        my $base2=substr($all{'R'},$i,1);
        if ($base1 ne $base2) {
            my $five1=substr($all{'L'},$i,5);
            my $five2=substr($all{'R'},$i,5);
            my $count1=0;
            for (my $j=0;$j<=4;$j++){
                my $base1_1=substr($five1,$j,1);
                my $base2_1=substr($five2,$j,1);
                if ($base1_1 ne $base2_1) {
                    $count1++;
                }
            }
            if ($count1>2) {
                my $five1=substr($all{'L'},$i,10);
                my $five2=substr($all{'R'},$i,10);
                my $count2=0;
                for (my $j=0;$j<=9;$j++){
                    my $base1_1=substr($five1,$j,1);
                    my $base2_1=substr($five2,$j,1);
                    if ($base1_1 ne $base2_1) {
                        $count2++;
                    }
                }
            
                if ($count2>4) {
                    my $l=substr($all{'L'},0,$i);
                    my $r=substr($all{'R'},0,$i);
                    $r=~tr/actgACTG/tgactgac/;
                    $r=reverse $r;
                    print OUT "$file\t$pos\t1,$pos,$l..$r,\n";
                    last LINE;
                }else{
                    $i+=5;
                }
            }
            
            #$count++;
            #if ($count==4) {
            #    print OUT "$file\t$pos\n";
            #    last LINE;
            #}   
        }else{
            $pos=$i+1;
        }
    }
}
close OUT;
