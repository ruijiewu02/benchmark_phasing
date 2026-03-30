source activate snakemake-env

cd ../snakemake

for fastq in ../data/Nanopore_R10_sup/*.nanopore.R10.sup.fastq.gz; do
    output=$(dirname $(dirname $fastq))
    snakemake --cores 64 --use-conda --conda-frontend conda --use-singularity --forcerun --configfile config/config_R10.yaml --config FASTQ=$fastq OUTDIR=../results/snakemake_running/Nanopore_R10_sup CLAIR3_PRESET_M=models/clair3/r1041_e82_400bps_sup_v410
done

conda deactivate
