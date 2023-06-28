
open(FILEA, "TE_list") or die FILEA;
while (<FILEA>) {
    chomp $_;
    my @linea=split/\t/,$_;

    my $clamp=$linea[0];
    my %all=();
    print "$clamp\n";
    open(FILE, "$clamp.rm") or die FILE;
    while (<FILE>) {
        $_=~s/[\(\)]//g;
        my @line=split/\s+/,$_;
        if ($line[9] eq 'C') {
            my $name=$line[5].','.$line[7];
            $all{$name}=$line[14].','.$line[13];
        }else{
            my $name=$line[5].','.$line[7];
            $all{$name}=$line[12].','.$line[13];
        }
    }
    close FILE;

    open(FILE, "$clamp.filter.fas") or die FILE;
    chomp(my @a=<FILE>);
    close FILE;
    
    my %all1=();
    $all1{'-1'}{start}=1;
    $all1{'-1'}{end}=$linea[3];
    $all1{'-1'}{start1}=0;
    $all1{'-1'}{end1}=0;
    for(my $i=0;$i<=$#a;$i+=2){
        my @line=split/[,;]/,$a[$i];
        if ($line[0] eq '>mite') {
            my $name1=$line[1].','.$line[3];
            my @name1=split/,/,$all{$name1};
            my $name2=$line[1].','.$line[6];
            my @name2=split/,/,$all{$name2};
            if ($line[7] eq 'C') {
                $all1{$i}{start}=$name2[1];
                $all1{$i}{end}=$name1[0];
                $all1{$i}{start1}=$line[9];
                $all1{$i}{end1}=$line[8];
                $all1{$i}{name}=$a[$i];
                $all1{$i}{seq}=$a[$i+1];
                #print OUT "$i,$all{$name2},$all{$name1}\n";
            }else{
                $all1{$i}{start}=$name1[1];
                $all1{$i}{end}=$name2[0];
                $all1{$i}{start1}=$line[8];
                $all1{$i}{end1}=$line[9];
                $all1{$i}{name}=$a[$i];
                $all1{$i}{seq}=$a[$i+1];
                #print OUT "$i,$all{$name1},$all{$name2}\n";
            }
            
        #}elsif($line[0] eq '>auto') {
        #    my $name1=$line[1].','.$line[3];
        #    my @name1=split/,/,$all{$name1};
        #    my $name2=$line[1].','.$line[6];
        #    my @name2=split/,/,$all{$name2};
        #    if ($line[7] eq 'C') {
        #        $all1{$i}{start}=$name2[1];
        #        $all1{$i}{end}=$name1[0];
        #        $all1{$i}{start1}=$line[8];
        #        $all1{$i}{end1}=$line[8];
        #        #print OUT "$i,$all{$name2},$all{$name1}\n";
        #    }else{
        #        $all1{$i}{start}=$name1[1];
        #        $all1{$i}{end}=$name2[0];
        #        $all1{$i}{start1}=$line[8];
        #        $all1{$i}{end1}=$line[8];
        #        #print OUT "$i,$all{$name1},$all{$name2}\n";
        #    }
        }
        
    }
    
    open(OUT1, ">$clamp\_1.mite") or die OUT1;
    open(OUT2, ">$clamp\_2.mite") or die OUT2;
    open(OUT3, ">$clamp\_3.mite") or die OUT3;
    my $tsj=0;
    for my $i(sort {$all1{$a}{start} <=> $all1{$b}{start}} keys %all1){
        print OUT1 "$tsj\t$all1{$i}{start}\t$all1{$i}{start1}\n$tsj\t$all1{$i}{end}\t$all1{$i}{end1}\n";
        $tsj++;
    }
    
    $tsj=0;
    for my $i(sort {$all1{$b}{end} <=> $all1{$a}{end}} keys %all1){
        print OUT2 "$tsj\t$all1{$i}{start}\t$all1{$i}{start1}\n$tsj\t$all1{$i}{end}\t$all1{$i}{end1}\n";
        $tsj++;
    }
    
    $tsj=0;
    for my $i(sort {$all1{$a}{start} <=> $all1{$b}{start}} keys %all1){
        print OUT3 "$tsj\t$all1{$i}{start}\t$all1{$i}{start1}\t$all1{$i}{end}\t$all1{$i}{end1}\t$all1{$i}{name}\t$all1{$i}{seq}\n";
        $tsj++;
    }
    close OUT1;
    close OUT2;
    close OUT3;
}