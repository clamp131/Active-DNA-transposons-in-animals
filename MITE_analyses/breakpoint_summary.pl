

open(OUT, ">breakpoint.out") or die OUT;
for my $file(glob "*_3.mite"){
    my %all=();
    open(FILE, $file) or die FILE;
    while (<FILE>) {
        chomp $_;
        my @line=split/\t/,$_;
        my $name=$line[1].";".$line[3];
        $all{$name}++;
    }
    close FILE; 
    print OUT "$file\t";
    my @all1=();
    for my $name(sort keys %all){
        if ($all{$name}>=3) { # at least 3 copies with the same breakpoints defined as conserved MITEs
            push (@all1,$name);
            #print "$name\n";
            print OUT "$name;$all{$name}\t";
        }
        
    }
    print OUT "\n";
    
    
}

