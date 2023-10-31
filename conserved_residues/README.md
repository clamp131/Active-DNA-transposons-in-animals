# Scripts to identify conserved residues in active DNA TEs

1. Collect the transposase sequences as a fasta file. Add the tag "a" ahead of the name of active TEs, "n" ahead of the name of inactive TEs.
  
   See the example `Tc1_Tn.fas`.
   
2. Generate alignments
   
   ```mafft Tc1_Tn.fasta >Tc1_Tn.fas```

3. **`perl conserved_residue.pl`**: find the absolute conserved residues, and report their relative posistions in SB100X. This script does not consider mutations in inactive TEs.

