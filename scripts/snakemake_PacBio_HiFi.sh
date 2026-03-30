source activate snakemake-env

cd ../snakemake

for fastq in ../data/PacBio_HiFi/*.pacbio.fastq.gz; do
    snakemake --cores 64 --use-conda --conda-frontend conda --use-singularity --forcerun --configfile config/config_PacBio_HiFi.yaml --config FASTQ=$fastq OUTDIR=../results/snakemake_running/PacBio_HiFi
done

conda deactivate
