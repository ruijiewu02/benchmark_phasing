source activate snakemake-env

cd ../snakemake

for fastq in ../data/Nanopore_R10_hac_HG002_HG005/*.nanopore.R10.hac.fastq.gz; do
    snakemake --cores 64 --use-conda --conda-frontend conda --use-singularity --forcerun --configfile config/config_R10.yaml --config FASTQ=$fastq OUTDIR=../results/snakemake_running/Nanopore_R10_hac_HG002_HG005
done

conda deactivate
