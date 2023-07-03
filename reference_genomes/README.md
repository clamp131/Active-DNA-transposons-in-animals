# Scripts to identify candidate DNA TEs in 100 animal reference genomes

1. Before running the perl codes, prepare the genome sequence and repeatmasker files.
   
   Using Xenopus tropicalis as an example, the genome file can be downloaded [here](https://hgdownload.soe.ucsc.edu/goldenPath/xenTro9/bigZips/),
   and the repeatmasker file can be downloaded [here](https://hgdownload.soe.ucsc.edu/goldenPath/xenTro9/database/rmsk.txt.gz).

   put the two files into the folder named `xenTro9`.
   
2. **`perl full_length_TE.pl`**: search for the full-length DNA TEs.
   
3. **`perl summary.pl`**: print the species, family, name, length, number and median divergence info of DNA TEs.
   
4. Extract the consensus sequences of DNA TEs from `RepBase24.02.fasta` and print them into file `RB.fas`. It should be noted that `RepBase24.02.fasta` can be downloaded from RepBase only with commercial registration.

5. **`ORFfinder`**: to predict the transposase genes, download and install [ORFfinder](https://ftp.ncbi.nlm.nih.gov/genomes/TOOLS/ORFfinder/linux-i64/).
   
   ```bash
   ORFfinder -in RB.fas -s 0 -ml 900 -out RB.fas.orf -outfmt 0
   ```

6. **`GENESCAN`**: For TEs from P and PIF/Harbinger superfamilies, where the transposase genes have exon-intron structures, [GENESCAN](http://hollywood.mit.edu/GENSCAN.html) was used to detect ORFs with default parameters.

7. **`Pfamscan`**: to predict the functional domains, install pfamscan through conda and download the [libraries](http://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/).

   ```bash
   pfam_scan.pl -fasta RB.fas.orf -dir .
   ```
8. **`perl filter_tnp.pl`**: search for ORFs encoding transposase domains.
