

open(FILE, "breakpoint.out") or die FILE;
while (<FILE>) { 
    chomp $_;
    my @line=split/\t/,$_;
    if (defined $line[1]) {
        my %all=();
        my $file=$line[0];
        open(FILE2, "$file") or die FILE2;
        while (<FILE2>) {
            chomp $_;
            my @line1=split/\t/,$_;
            $all{$line1[0]}{start}=$line1[1];
            $all{$line1[0]}{end}=$line1[3];
            $all{$line1[0]}{seq}=$line1[6];
            $all{$line1[0]}{info}=$line1[5];
            $all{$line1[0]}{name}="$line1[0]_$line1[1]_$line1[3]";
        }
        close FILE2;
        
        my %all1=();
        open(OUT, ">$line[0].inter.fas") or die OUT;
        for(my $i=1;$i<=$#line;$i++){
            my @line2=split/;/,$line[$i];
            for my $tag(sort keys %all){
                if (abs($all{$tag}{start}-$line2[0])<=50 || abs($all{$tag}{end}-$line2[1])<=50) {
                    if (!defined $all1{$tag}) {
                        my @line3=split/,/,$all{$tag}{info};
                        if ($line3[7] eq '+') {
                            my $len1=$line3[3]-$line3[2]+1;
                            my $len2=$line3[6]-$line3[5]+1;
                            if (length($all{$tag}{seq})-$len1-$len2>0) {
                                my $base=substr($all{$tag}{seq},$len1,length($all{$tag}{seq})-$len1-$len2);
                                if (length($base)>0) {
                                    print OUT ">$all{$tag}{name}\n$base\n";
                                }
                            }else{
                                print OUT ">$all{$tag}{name}\n\n";
                            }
                        }else{
                            my $len2=$line3[3]-$line3[2]+1;
                            my $len1=$line3[6]-$line3[5]+1;
                            if (length($all{$tag}{seq})-$len1-$len2>0) {
                                my $base=substr($all{$tag}{seq},$len1,length($all{$tag}{seq})-$len1-$len2);
                                if (length($base)>0) {
                                    print OUT ">$all{$tag}{name}\n$base\n";
                                }
                            }else{
                                print OUT ">$all{$tag}{name}\n\n";
                            }
                        }
                        #print OUT ">$tag,$all{$tag}{start},$all{$tag}{end}\n$all{$tag}{seq}\n";
                        $all1{$tag}++;
                    } 
                } 
            }
        }
        close OUT;
    }  
}
close FILE;
