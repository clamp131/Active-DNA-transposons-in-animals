# Scripts to identify candidate DNA TEs in de novo assemblied genomes

1. Prepare the genome sequence files. For example, cavefish.fa.
   
2. BuildDatabase -name cavefish -engine ncbi cavefish.fa

3. RepeatModeler -engine ncbi -pa 30 -database cavefish

4. ORFfinder: to predict the transposase genes, download and isntall ORFfinder: https://ftp.ncbi.nlm.nih.gov/genomes/TOOLS/ORFfinder/linux-i64/.
   
   ORFfinder -in cavefish-families.fa -s 0 -ml 900 -out cavefish-families.fa.orf -outfmt 0

5. Pfamscan: to predict the fuctional domains, install pfamscan through conda and download the libraries: http://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/.

   pfam_scan.pl -fasta cavefish-families.fa.orf -dir .

6. perl filter_tnp.pl: search for ORFs encoding transposase domains.

7. Manually check the flanking sequences and reconstruct the boundaries of TEs.
