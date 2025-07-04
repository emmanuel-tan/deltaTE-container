FROM bioconductor/bioconductor_docker:RELEASE_3_18 as builder

RUN R -e "options(Ncpus = parallel::detectCores()); \
    if(!require('BiocManager')) install.packages('BiocManager'); \
    BiocManager::install(c('DESeq2', 'apeglm'), ask=FALSE); \
    install.packages('ggplot2');"

FROM r-base:4.3.0

LABEL maintainer="emmanueltan2000@gmail.com"

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    libgomp1 \
    libgsl-dev \
    libgmp-dev \
    libmpfr-dev \
    liblapack3 \
    libblas3 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/lib/R/site-library /usr/local/lib/R/site-library
COPY --from=builder /usr/local/lib/R/library /usr/local/lib/R/library

RUN find /usr/local/lib/R -name "help" -type d -exec rm -rf {} + && \
    find /usr/local/lib/R -name "html" -type d -exec rm -rf {} + && \
    find /usr/local/lib/R -name "doc" -type d -exec rm -rf {} + && \
    find /usr/local/lib/R -name "demo" -type d -exec rm -rf {} + && \
    find /usr/local/lib/R -name "tests" -type d -exec rm -rf {} + && \
    rm -rf /tmp/*

WORKDIR /app
COPY scripts/DTEG.R /app/
RUN chmod +x /app/DTEG.R

ENTRYPOINT ["Rscript", "/app/DTEG.R"]