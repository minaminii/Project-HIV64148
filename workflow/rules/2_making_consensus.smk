from snakemake.utils import min_version
min_version("7.0")

rule error_correction:
    input: "data/raw_reads.fastq"
    output: 
    shell: 

rule read_clustering:
    input: 
    output: 
    shell: 

rule haplotype_removal:
    input:
    output:
    shell:

rule low_freq_haplotype_removal:
    input:
    output:
    shell:

rule test_strainline:
    singularity: ""
    input: ""
    output: 
        "output/stdout.txt"
    shell:
        "strainline.sh -h > {output}"

rule strainline:
    input: 
        fastq = "data/input.fastq"
    output:
        out_haplotype = "data/"
    shell:
    """
    strainline.sh \
    -i {input.fastq} \
    -o {output.out_haplotype} \
    -p {config[platform]} \
    --minTrimmedLen {config[mintrimlen]} \
	--topk {config[topk]} \
	--minOvlpLen {config[minoverlap]} \
	--minIdentity {config[miniden]} \
	--minSeedLen {config[minseedlen]} \
	--maxOH {config[maxoh]} \
	--iter {config[iter]} \
	--maxGD {config[maxgd]} \
	--maxLD {config[maxld]} \
	--maxCO {config[maxco]} \
	--minAbun {config[min_abun]} \
	--rmMisassembly {config[rm_mis_asm]} \
	--correctErr {config[err_cor]} \
	--threads {config[thread]}
    """
