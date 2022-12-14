FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y apt-utils
RUN apt-get install -y build-essential
RUN apt-get install -y cmake
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y libboost-all-dev
RUN apt-get install -y libcurl-dev
RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN apt-get install -y nano
RUN apt-get install -y python3 python3-pip python-is-python3

# Install Git
RUN apt-get install -y git

# Install samtools
RUN apt-get install -y samtools

# Install pycoQC
RUN ["pip3", "install", "git+https://github.com/a-slide/pycoQC.git"]

# Install daccord
WORKDIR /opt
RUN ["wget", "https://github.com/gt1/daccord/releases/download/0.0.10-release-20170526170720/daccord-0.0.10-release-20170526170720-x86_64-etch-linux-gnu.tar.gz"]
RUN ["tar", "-zvxf", "daccord-0.0.10-release-20170526170720-x86_64-etch-linux-gnu.tar.gz"]
RUN ["rm", "daccord-0.0.10-release-20170526170720-x86_64-etch-linux-gnu.tar.gz"]
RUN ["ln", "-fs", "/opt/daccord-0.0.10-release-20170526170720-x86_64-etch-linux-gnu/bin/daccord", "/usr/local/bin/daccord"]

# Install Minimap2
WORKDIR /opt
RUN ["git", "clone", "https://github.com/lh3/minimap2"]
WORKDIR /opt/minimap2
RUN make
RUN ["ln", "-fs", "/opt/minimap2/minimap2", "/usr/local/bin/minimap2"]

# Install spoa
WORKDIR /opt
RUN ["git", "clone", "https://github.com/rvaser/spoa"]
WORKDIR /opt/spoa/build
RUN ["cmake", "-DCMAKE_BUILD_TYPE=Release", ".."]
RUN make
RUN ["ln", "-fs", "/opt/spoa/build/bin/spoa", "/usr/local/bin/spoa"]

# Install MetaBAT
WORKDIR /opt
RUN ["wget", "https://bitbucket.org/berkeleylab/metabat/get/master.tar.gz"]
RUN ["tar", "-zvxf", "master.tar.gz"]
RUN ["rm", "master.tar.gz"]
WORKDIR /opt/berkeleylab-metabat-*/build
RUN ["cmake", "/opt/berkeleylab-metabat-d6ea400244b8/"]
RUN make
RUN make test
RUN make install

# Install DAZZ_DB
WORKDIR /opt
RUN ["git", "clone", "https://github.com/thegenemyers/DAZZ_DB.git"]
RUN make -C /opt/DAZZ_DB
RUN make install -C /opt/DAZZ_DB DEST_DIR=/usr/local/bin

# Install DALIGNER
WORKDIR /opt
RUN ["git", "clone", "https://github.com/thegenemyers/DALIGNER.git"]
RUN make -C DALIGNER
RUN make install -C DALIGNER DEST_DIR=/usr/local/bin

# Install Strainline
WORKDIR /opt
RUN ["git", "clone", "https://github.com/HaploKit/Strainline.git"]
RUN ["ln", "-fs", "/opt/Strainline/src/strainline.sh", "/usr/local/bin/strainline"]

WORKDIR /workspace
ENV PATH="${PATH}:/usr/local/bin/"
CMD ["/bin/bash"]
