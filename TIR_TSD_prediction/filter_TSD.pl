
open(FILE1, "list") or die FILE1;
while (<FILE1>) {
    chomp $_;
    my @line=split/\t/,$_;
    my $tag=$line[0];
    my $len=$line[5]; # the TSD length
    open(FILE, "$tag.fk1.fas") or die FILE;
    chomp (my @a1=<FILE>);
    close FILE;
    
    open(FILE, "$tag.fk2.fas") or die FILE;
    chomp (my @a2=<FILE>);
    close FILE;
    
    open(FILE, "$tag.fas") or die FILE;
    chomp (my @a3=<FILE>);
    close FILE;
    
    open(OUT1, ">$tag.fk1.filter.fas") or die OUT1;
    open(OUT2, ">$tag.fk2.filter.fas") or die OUT2;
    open(OUT3, ">$tag.filter.fas1") or die OUT3;
    for(my $i=0;$i<=$#a1;$i+=2){
        my $seq1=substr($a1[$i+1],-$len,);
        my $seq2=substr($a2[$i+1],0,$len);
        #print "$seq1\t$seq2\n";
        #sleep 2;
        $seq1=~tr/atcg/ATCG/;
        $seq2=~tr/atcg/ATCG/;
        if ($a1[$i] eq $a2[$i] && $seq1 eq $seq2) { # the TSDs should be the same
            print OUT1 "$a1[$i]\n$a1[$i+1]\n";
            print OUT2 "$a2[$i]\n$a2[$i+1]\n";
            print OUT3 "$a3[$i]\n$a3[$i+1]\n";
        }
    }
    close OUT1;
    close OUT2;
    close OUT3;
}
close FILE1;