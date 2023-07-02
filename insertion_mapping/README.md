# Insersion site mapping workflow

This is a [Snakemake](https://github.com/snakemake/snakemake) workflow for recovering the TE insertion sites from sequencing data.

## Dependencies installation

- [Snakemake](https://github.com/snakemake/snakemake) needs to be installed before runnig the workflow.
- Other dependencies are defined by [`workflow/env/*.yaml`](workflow/env/) and can be automaticly installed if [Conda](https://github.com/conda/conda) or [Mamba](https://github.com/mamba-org/mamba) is available. Otherwise, manual insallation of these packages are needed. 

## Preparing genome files

Path to hg38 genome files (fasta, fasta index and the novoalign index) needs to be specified in [`config/config.yaml`](config/config.yaml):

```yaml
genome:
    fa: input/hg38/hg38.fa
    fai: input/hg38/hg38.fa.fai
    ndx: input/hg38/genome.ndx
```

The novoalign index can be built by the `novoindex` command:

```bash
novoindex genome.ndx hg38.fa
```

## Preparing sequencing files

Path to sequencing files and details for each TE is specified in [`config/sample_table.csv`](config/sample_table.csv). More lines can be added for other samples.

## Workflow execution

With input files prepared, the workflow can be executed using the following commands:

```bash
# `-j 32` specifies number of threads to use
# drop the `--use-conda` option if conda/mamba is not available
snakemake -j 32 --use-conda
```

The insertion sites will be saved to `result/gentsd/*~nostr.bed` using BED format.
