# Scripts to identify candidate DNA TEs in de novo assemblied genomes

1. Prepare the genome sequence files. For example, `cavefish.fa`.
   
2. ```bash
   BuildDatabase -name cavefish -engine ncbi cavefish.fa
   ```

3. ```bash
   RepeatModeler -engine ncbi -pa 30 -database cavefish
   ```

4. **`ORFfinder`**: to predict the transposase genes, download and install [ORFfinder](https://ftp.ncbi.nlm.nih.gov/genomes/TOOLS/ORFfinder/linux-i64/).
   
   ```bash
   ORFfinder -in cavefish-families.fa -s 0 -ml 900 -out cavefish-families.fa.orf -outfmt 0
   ```

5. **`Pfamscan`**: to predict the functional domains, install pfamscan through conda and download the [libraries](http://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/).

   ```bash
   pfam_scan.pl -fasta cavefish-families.fa.orf -dir .
   ```

6. **`perl filter_tnp.pl`**: search for ORFs encoding transposase domains.

7. Manually check the flanking sequences and reconstruct the boundaries of TEs.
