FROM bioconductor/bioconductor_docker:3.21-r-4.5.1

ENV DEBIAN_FRONTEND=noninteractive

RUN R -q -e "BiocManager::install( \
       c('DESeq2','apeglm'), \
       ask=FALSE, update=FALSE)" \
 && R -q -e "install.packages( \
       c('ggplot2'), \
       repos='https://cloud.r-project.org')" \
 # sanity check: fail the build if libs don’t load
 && R -q -e "library(DESeq2); library(apeglm); sessionInfo()"

COPY scripts/ /home/ruser/scripts/

RUN chmod +x /home/ruser/scripts/*.R

WORKDIR /home/ruser

ENTRYPOINT ["Rscript", "/home/ruser/scripts/DTEG.R"]