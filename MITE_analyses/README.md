# Scripts to analyze the evolutionary modes of MITEs

1. Prepare the TE info file `TE_list`, the repeatmasker output files generated by `extract_TE.pl` (e.g., `1.rm` for hAT-2_AG), and the files containing TE copies with perfect TSDs generated by `filter_TSD.pl` (e.g., `1.filter.fas`) in folder `TIR_TSD_prediction`.

2. **`perl extract_mite.pl`**: It will output three files, e.g., `1_1.mite`, `1_2.mite` and `1_3.mite`. The first two are used for dot plot, and the last one is for alignment.

3. Dotplot in R of the internal breakpoints of MITEs against the consensus TEs.

   ```R
   pdf("1.pdf")
   dat1=read.table("1_1.mite")
   names(dat1)=c("order","pos","div")
   dat2=read.table("1_2.mite")
   names(dat2)=c("order","pos","div")
   p1=ggplot(dat1,aes(x=pos,y=order))+geom_point()
   p2=ggplot(dat2,aes(x=pos,y=order))+geom_point()
   plot_grid(p1,p2,ncol=1)
   dev.off()
   ```

5. **`perl breakpoint_summary.pl`**: list the conserved MITEs which are defined as those with conserved (at least three copies) breakpoints.

6. **`perl extract_internal_seq.pl`**: MITEs may contain sequences unrelated to consensus TEs. This script is used to extract these sequences for alignment by mafft.


