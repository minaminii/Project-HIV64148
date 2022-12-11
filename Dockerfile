FROM "snakemake/snakemake"
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y git wget nano samtools

COPY workflow /workflow
WORKDIR /workflow
WORKDIR /workflow/envs/strainline
RUN singularity build minamini-strainline.sif docker-archive://minamini-strainline.tar
WORKDIR /workflow
CMD ["/bin/bash"]
