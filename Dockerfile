FROM rocker/r-ver:4.3.1

LABEL maintainer="emmanueltan2000@gmail.com"
LABEL description="deltaTE: Detection of translationally regulated genes"

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libpng-dev \
    libxt-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages('BiocManager', dependencies=TRUE)" \
 && R -e "install.packages('ggplot2', dependencies=TRUE)" \
 && R -e "BiocManager::install(c('DESeq2', 'apeglm'), dependencies=TRUE, ask=FALSE)"

WORKDIR /app

COPY scripts/DTEG.R /app/

RUN chmod +x /app/DTEG.R

ENTRYPOINT ["Rscript", "/app/DTEG.R"]

# docker run --rm \
#   --platform=linux/amd64 \
#   -v $(pwd)/examples:/data \
#   -w /data \
#   delta-te ribo_counts.txt rna_counts.txt sample_info.txt 1