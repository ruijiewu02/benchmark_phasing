source activate snakemake-env

cd ../snakemake

for fastq in ../data/Nanopore_R9_sup/*.nanopore.R9.sup.fastq.gz; do
    snakemake --cores 64 --use-conda --conda-frontend conda --use-singularity --forcerun --configfile config/config_R9.yaml --config FASTQ=$fastq OUTDIR=../results/snakemake_running/Nanopore_R9_sup
done
conda deactivate
