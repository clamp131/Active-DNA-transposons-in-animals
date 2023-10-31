
my %active=();
my %inactive=();
my %all=();
my $name='';
my $num=0;
open(FILE, "Tc1_Tn.fas") or die FILE;
while (<FILE>) {
    chomp $_;
    if ($_=~/^>a/) { #count the total number of active TEs;
        $num++;
    }
    
    if ($_=~/^>/) {
        $name=substr($_,1,);
    }else{
        $all{$name}.=$_;
    }
}
close FILE;

open(OUT, ">Tc1_Tn.conserved.txt") or die OUT;
print OUT "pos_without_gap\tpos_with_gap\tresidue\n";

my $pos=0;
for (my $i=0;$i<length($all{'aSB100X'});$i++){
    my $base1=substr($all{'aSB100X'},$i,1);
    if ($base1 ne '-') {
        $pos++;
        my $num_con=0;
        for my $te(sort keys %all){
            my $base2=substr($all{$te},$i,1);
            if ($te=~/^a/ && $base2 eq $base1) { #judge whether the residue is the same to that of SB100X;
                $num_con++;  
            } 
        }
        if ($num_con == $num) {  #the residue is conserved in all active TEs;
            print OUT "$pos\t$i\t$base1\n"; #print the relative position of the residue in SX100X;
        }
    }
}
close OUT;
