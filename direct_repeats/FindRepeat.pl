##obtain reverse complement sequence
sub reverse_complement {
        my $dna = shift;
        my $revcomp = reverse($dna);
        $revcomp =~ tr/ACGTacgt/TGCAtgca/;
        return $revcomp;
}


##Set kmer length
$kmer=$ARGV[0];

##convert right boundary sequence to reverse complement sequence and researve kmer
open (FINA,$ARGV[1]);
do {
	$flag = defined ($str=<FINA>);
	chomp $str;
	if ($str=~/^>/ || $flag==0) {
		if ($seq ne "") {
			$rev=reverse_complement($seq);
			$convert=uc($rev);
			@arr=split(//,$convert);
			@tmp=split(/-R/,$id);
			for ($i=0;$i<scalar @arr-$kmer;$i++){
				$k{$tmp[0]}{$i}=substr($convert,$i,$kmer);
			}
		}
		$id = substr($str,1);
		$seq = "";
	} else {
		$seq = $seq.$str;
	}
} while ($flag);


##Read left boudary sequence and compare to the kmer in right boudary sequence (reverse complement)
open (FINB,$ARGV[2]);
do {
	$flag = defined ($str=<FINB>);
	chomp $str;
	if ($str=~/^>/ || $flag==0) {
		if ($seq ne "") {
			$convert=uc($seq);
			@tmp=split(/-L/,$id);
			@arr=split(//,$convert);
			for ($i=0;$i<scalar @arr-$kmer;$i++){
				foreach my $j (sort {$a <=> $b} keys %{$k{$tmp[0]}}){
					if ($k{$tmp[0]}{$j} eq substr($convert,$i,$kmer)){
						$left_pos=$i+1;
						$right_pos=$j+1;
						$tag1=$tmp[0]."_".$k{$tmp[0]}{$j};
						$tag2=$left_pos."_".$right_pos;
						$hash{$tag1}{$tag2}=1;
						$count{$tmp[0]}{$k{$tmp[0]}{$j}}++;
						#print  $tmp[0],"\t",$k{$tmp[0]}{$j},"\t",$i+1,"\t",$j+1,"\n";
					}
				}
			}
		}
		$id = substr($str,1);
		$seq = "";
	} else {
		$seq = $seq.$str;
	}
} while ($flag);


##Output format:
##col1: gene name
##col2: repeat count
##col3: repeat seqence
##col4: position in left boudary sequence
##col5: position in right boudary seqeunce (reverse complement)
foreach my $id (keys %count){
	foreach my $kmer (sort {$count{$id}{$b} <=> $count{$id}{$a}} keys %{$count{$id}}){
		$tmp=$id."_".$kmer;
		foreach my $pos (sort {$a<=>$b} keys %{$hash{$tmp}}){
			@arr=split(/_/,$pos);
			print $id,"\t",$count{$id}{$kmer},"\t",$kmer,"\t",$arr[0],"\t",$arr[1],"\n";
		}
	}
}
