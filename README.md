# Pipeline

# Purpose

- Dependency management and installation of tools is a time consuming process.
- Allows scienctist to focus on science rather than software.
- This container contains software used in HIV quasispecies analysis pipeline
- The pipeline can be used for long-read only or hybrid analysis
- The pipeline produces quansispecie sequences, consensus sequence, and variant calling files

This is a software package incoperated with pipeline for an analysis of viral genome. It can performs reference based consensus assembly, variant calling and reference-free quasispecies assembly and identification on long-read data particularily from Oxford Nanopore technology. This software package aims to consolidate analytical tools needed for the analysis into a single, easy to use, portable Docker container which can be rapidly deployed on any machine regardless of its environment.

Wrapped around a software package is an analysis pipeline uses viral haplotypes assembler pipeline, Strainline, from [HaploKit](https://github.com/HaploKit) to produce quansispecie sequences witout the need of reference genome, this pipeline produces corrected read using local de bruijn graph construction method, this corrected read is also used by NanoCaller to call out the variation, the output VCF files (indel, snps) are then annotated using variant annotator and effect prediction tool, SnpEff. This same corrected reads then go into mulitple iteration of seed and cluster producing haplotigs which are then finalized into full-lenght haplotypes, these haplotypes are identified against a database of 32 HIV strains of selected laboratory clones, subtypes, and CRFs. The consensus sequence is produced by NanoHIV pipeline from [ramics](https://github.com/ramics) which uses multiple iterations of alignment and polishing with Nanopolish to produce a final consensus sequence.

# Installation

There is no installation for this pipeline - it can be invoked directly on the command line using Snakemake (see [instruction](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html)).

To invoke the pipeline `cd` into the workflow directory (where Snakefile is located) and simply call `snakemake -c${threads} --use-conda --use-singularity all`.

# The pipeline

We only require user to specified input and tweak some configuration, both dependencies and installation of the analysis softwares are managed by Snakemake conda environment and Singularity images provided with the pipeline.

## Configuration

The pipeline configuration file is in a yaml format and is located in a config directory, users can customize parameters as needed for each run.

### Input

You can place your input into `./input` directory. On this current version, custom file name is not supported, please name your input as …..

### Output

Your output will be present on `./output` directory after the pipline finished. Important output will be structured in directories as follow.

- output
    - alignment
        - reads_alignment.bam
        - reads_alignment.bam.bai
    - NanoHIV
        - consensus.fasta
    - strainline
        - haplotypes.final.fa
    - varient_calls
        - variant_snps.vcf
        - variant_indels.vcf
    - haplotype.blast.txt

### BLAST database

The database was created using selected laboratory clones, subtypes, and CRFs of 32 HIV strains listed in the supplementary ___ . This database is used to identified quasispecies produced by Strainline via BLASTN software.

## Tools

- Snakemake v7.18.2
- Strainline
    - d'accord v0.0.10
    - spoa v4.0.9
    - jgi_summarize_bam_contig_depths from metabat2
- Minimap2 v2.24
- Samtools v.1.10
- Nanocaller v3.0.0
- BLASTN v2.13.0+

### To be implemented

- Polypolish
- Medaka
- ShoRah
- SnpEff

## Process

```mermaid
flowchart TD
start([Start])
raw_sig[Raw signal .fast5]
raw_read[Raw reads .fastq]
basecall_sum[Basecalls summary]
pycoqc[[pycoQC]]
qc_report([fa:fa-file-lines QC report])
long_read_ec[[Long read error correction]]
corr_read[Corrected reads]
seed_n_cluster[Seed & Cluster]
clus_con[Clustered contigs]
haplotigs[Haplotigs]
quasispecies([fa:fa-split Quasispecies])
consensus([Consensus sequence])
hybrid{Hybrid calls?}
hybrid_polish{Hybrid polish?}
polish([Polished sequences])
vcf([VCF])
annot([Annotated VCF])
nanohiv[[NanoHIV]]
Polyposlih[[Polyposlih]]
Medaka[[Medaka]]
Shorah[[Shorah]]
Nanocaller[[Nanocaller]]
snpeff[[SnpEff]]
blast[[BLAST+]]
iden([Quasispecies' Identities])

classDef implemented fill:#B6E2A1,stroke:#333,stroke-width:1.5px
classDef not_tested fill:#FFFBC1,stroke:#333,stroke-width:1.5px
classDef unresolved fill:#FEBE8C,stroke:#333,stroke-width:1.5px
classDef incorrect fill:#F7A4A4,stroke:#333,stroke-width:1.5px

start --> raw_sig
raw_sig --> |Basecaller| Basecalls
raw_sig --> nanohiv
Basecalls --o raw_read
Basecalls --o basecall_sum
raw_read --> long_read_ec
raw_read --> nanohiv
basecall_sum --> pycoqc
subgraph snakemake/snakemake
    subgraph pycoQC
        pycoqc:::implemented --- qc_report:::implemented
    end
	subgraph NanoHIV
        nanohiv:::not_tested --- polish
				polish  --> hybrid_polish
        hybrid_polish --> |Yes| Polyposlih --- consensus
        hybrid_polish --> |No| Medaka --- consensus
    end
    subgraph minamini/strainline
        long_read_ec:::implemented --> |d'accord| corr_read
        corr_read:::implemented --> seed_n_cluster
        seed_n_cluster:::implemented --> clus_con
        clus_con:::implemented --> haplotigs
        haplotigs:::implemented --> |Multiple iterations| seed_n_cluster
        haplotigs --> |Low freq haplotype removal| quasispecies:::implemented
    end
    subgraph variant_caller
        corr_read --> hybrid
        hybrid --> |Yes| Shorah --- vcf:::unresolved
        hybrid --> |No| Nanocaller:::unresolved--- vcf
        vcf --o indel.vcf:::incorrect --> snpeff
        vcf --o snps.vcf:::unresolved --> snpeff
        snpeff --- annot
    end
    subgraph BLAST+
        quasispecies --> blast:::implemented
        blast --- iden:::implemented
    end
end
```

# Known issue

- NanoHIV requires .fast5 files which aren’t avilable on GCP compute instance, waiting for upload.
- Nanocaller has issue with paralell processing
- Nanocaller calls low-quality snps
- Nanocaller produces empty indel file

# To optimize

- BLAST+ produces a report with cross-alignment data of all quasispecies vs database which makes the report cluttered and difficult to interprete.
- Interactive command-line based software to control custom input/output and configuration (currently I/O require user to change their name into specified name)