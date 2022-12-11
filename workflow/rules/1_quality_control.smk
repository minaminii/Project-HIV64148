from snakemake.utils import min_version
min_version("7.0")
rule test_pycoqc: 
    output: "stdout.txt"
    shell: "conda run -n pycoQC pycoQC -h > {output}"
rule quality_control:
    configfile: envs/strainline/config.yaml
        summary_file = "data/summary/{run}/sequencing_summary.txt"
    output: 
        quality_report = "output/quality_report/{run}/qc_{run}.html"
    shell:
        """
        conda run -n pycoQC pycoQC –f {summary_file} –o {quality_report}
        """
    conda:
        "envs/pycoqc.yaml"
