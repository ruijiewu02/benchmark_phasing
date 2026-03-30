### This scripts is used to run the upstream snakemake pipeline in 3 downsampling individuals from different platforms.

source activate snakemake-env

cd ../../../snakemake

for fastq in ../results/downsampling/data1/HG02723/HG02723.pacbio.*.fastq.gz; do
    echo $fastq; 
    snakemake --cores 64 --use-conda --conda-frontend conda --use-singularity --forcerun \
    --configfile config/config_PacBio_HiFi.yaml \
    --config FASTQ=$fastq OUTDIR=../results/downsampling/results/snakemake_running/HG02723
done

for fastq in ../results/downsampling/data1/HG00733/HG00733.nanopore.R9.hac.*.fastq.gz; do
    echo $fastq; 
    snakemake --cores 64 --use-conda --conda-frontend conda --use-singularity --forcerun \
    --configfile config/config_Nanopore_R9.yaml \
    --config FASTQ=$fastq OUTDIR=../results/downsampling/results/snakemake_running/HG00733
done

for fastq in ../results/downsampling/data1/NA20129/NA20129.nanopore.R10.hac.*.fastq.gz; do
    echo $fastq; 
    snakemake --cores 64 --use-conda --conda-frontend conda --use-singularity --forcerun \
    --configfile config/config_Nanopore_R10.yaml \
    --config FASTQ=$fastq OUTDIR=../results/downsampling/results/snakemake_running/NA20129 CLAIR3_PRESET_M=models/clair3/r1041_e82_400bps_hac_v410
done

conda deactivate