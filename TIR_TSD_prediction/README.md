# Scripts to predict TIR and TSD of DNA TEs

1. Prepare the TE info file `TE_list`, TE sequence file `TE_list.fas` (examples are in this folder) and genome sequence file (be sure that the name is the same to that in `TE_list`).

   In `TE_list`, the columns represent: TE tag, TE name, genome, TE length, superfamily, TSD length (from previous literature).

   For convenience, the TE name in `TE_list.fas` was replaced by TE tag.

2. **`perl extract_TE.pl`**:

   Before running this script, install RepeatMasker. The script will re-annotate the genome using the sequence of each DNA TE, and extract the auto and MITE copies as well as the flanking 100-bp sequences.

   Example output files of hAT-2_AG are shown in this folder:
   - `1.rm` is the repeatmasker out;
   - `1.fas` is the auto and MITE copies;
   - `1.fk1.fas` is the 5' flanking sequence; and
   - `1.fk2.fas` is the 3' flanking sequence.

3. **`perl filter_TSD.pl`**:

   Find the TE copies with perfect TSDs. The TSD length info was from previous literature. For example, hAT-2_AG belonging to hAT superfamily should have 8-bp TSDs.
   
   Example output files of hAT-2_AG are shown in this folder:
   - `1.filter.fas` is the auto and MITE copies;
   - `1.fk1.filter.fas` is the 5' flanking sequence; and
   - `1.fk2.filter.fas` is the 3' flanking sequence.

4. **`perl TIR_predict.pl`**:

   Before running this script, install mafft. It will report the TIRs of each TE. Mismatches were allowed.
