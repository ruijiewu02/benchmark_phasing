### This script is used to downsampling three individuals in different platforms
THREADS=48

### PacBio HiFi (HG02723)
INDIR=../../snakemake_running/PacBio_HiFi/results.HG02723.pacbio/02_samtools_samfile_process
OUTDIR=../data/HG02723
if [ ! -d $OUTDIR ]; then
    mkdir -p $OUTDIR;
fi

samtools view -bS -s 0.2047 -@ $THREADS $INDIR/HG02723.pacbio.sorted.bam > $OUTDIR/HG02723.pacbio.10x.sorted.bam
samtools index -@ $THREADS $OUTDIR/HG02723.pacbio.10x.sorted.bam
samtools view -bS -s 0.4094 -@ $THREADS $INDIR/HG02723.pacbio.sorted.bam > $OUTDIR/HG02723.pacbio.20x.sorted.bam
samtools index -@ $THREADS $OUTDIR/HG02723.pacbio.20x.sorted.bam
samtools view -bS -s 0.6140 -@ $THREADS $INDIR/HG02723.pacbio.sorted.bam > $OUTDIR/HG02723.pacbio.30x.sorted.bam
samtools index -@ $THREADS $OUTDIR/HG02723.pacbio.30x.sorted.bam
samtools view -bS -s 0.8187 -@ $THREADS $INDIR/HG02723.pacbio.sorted.bam > $OUTDIR/HG02723.pacbio.40x.sorted.bam
samtools index -@ $THREADS $OUTDIR/HG02723.pacbio.40x.sorted.bam


### Nanopore R9 (HG00733)
INDIR=../../snakemake_running/Nanopore_R9_hac/results.HG00733.nanopore.R9.hac/02_samtools_samfile_process
OUTDIR=../data/HG00733
if [ ! -d $OUTDIR ]; then
    mkdir -p $OUTDIR;
fi

samtools view -bS -s 0.1485 -@ $THREADS $INDIR/HG00733.nanopore.R9.hac.sorted.bam > $OUTDIR/HG00733.nanopore.R9.hac.10x.sorted.bam
samtools index -@ $THREADS $OUTDIR/HG00733.nanopore.R9.hac.10x.sorted.bam
samtools view -bS -s 0.2969 -@ $THREADS $INDIR/HG00733.nanopore.R9.hac.sorted.bam > $OUTDIR/HG00733.nanopore.R9.hac.20x.sorted.bam
samtools index -@ $THREADS $OUTDIR/HG00733.nanopore.R9.hac.20x.sorted.bam
samtools view -bS -s 0.4454 -@ $THREADS $INDIR/HG00733.nanopore.R9.hac.sorted.bam > $OUTDIR/HG00733.nanopore.R9.hac.30x.sorted.bam
samtools index -@ $THREADS $OUTDIR/HG00733.nanopore.R9.hac.30x.sorted.bam
samtools view -bS -s 0.5939 -@ $THREADS $INDIR/HG00733.nanopore.R9.hac.sorted.bam > $OUTDIR/HG00733.nanopore.R9.hac.40x.sorted.bam
samtools index -@ $THREADS $OUTDIR/HG00733.nanopore.R9.hac.40x.sorted.bam
samtools view -bS -s 0.7423 -@ $THREADS $INDIR/HG00733.nanopore.R9.hac.sorted.bam > $OUTDIR/HG00733.nanopore.R9.hac.50x.sorted.bam
samtools index -@ $THREADS $OUTDIR/HG00733.nanopore.R9.hac.50x.sorted.bam
samtools view -bS -s 0.8908 -@ $THREADS $INDIR/HG00733.nanopore.R9.hac.sorted.bam > $OUTDIR/HG00733.nanopore.R9.hac.60x.sorted.bam
samtools index -@ $THREADS $OUTDIR/HG00733.nanopore.R9.hac.60x.sorted.bam

### Nanopore R10 (NA20129)
INDIR=../../snakemake_running/Nanopore_R10_hac/results.NA20129.nanopore.R10.hac/02_samtools_samfile_process
OUTDIR=../data/NA20129
if [ ! -d $OUTDIR ]; then
    mkdir -p $OUTDIR;
fi

samtools view -bS -s 0.1359 -@ $THREADS $INDIR/NA20129.nanopore.R10.hac.sorted.bam > $OUTDIR/NA20129.nanopore.R10.hac.10x.sorted.bam
samtools index -@ $THREADS $OUTDIR/NA20129.nanopore.R10.hac.10x.sorted.bam
samtools view -bS -s 0.2718 -@ $THREADS $INDIR/NA20129.nanopore.R10.hac.sorted.bam > $OUTDIR/NA20129.nanopore.R10.hac.20x.sorted.bam
samtools index -@ $THREADS $OUTDIR/NA20129.nanopore.R10.hac.20x.sorted.bam
samtools view -bS -s 0.4078 -@ $THREADS $INDIR/NA20129.nanopore.R10.hac.sorted.bam > $OUTDIR/NA20129.nanopore.R10.hac.30x.sorted.bam
samtools index -@ $THREADS $OUTDIR/NA20129.nanopore.R10.hac.30x.sorted.bam
samtools view -bS -s 0.5438 -@ $THREADS $INDIR/NA20129.nanopore.R10.hac.sorted.bam > $OUTDIR/NA20129.nanopore.R10.hac.40x.sorted.bam
samtools index -@ $THREADS $OUTDIR/NA20129.nanopore.R10.hac.40x.sorted.bam
samtools view -bS -s 0.6796 -@ $THREADS $INDIR/NA20129.nanopore.R10.hac.sorted.bam > $OUTDIR/NA20129.nanopore.R10.hac.50x.sorted.bam
samtools index -@ $THREADS $OUTDIR/NA20129.nanopore.R10.hac.50x.sorted.bam
samtools view -bS -s 0.8155 -@ $THREADS $INDIR/NA20129.nanopore.R10.hac.sorted.bam > $OUTDIR/NA20129.nanopore.R10.hac.60x.sorted.bam
samtools index -@ $THREADS $OUTDIR/NA20129.nanopore.R10.hac.60x.sorted.bam
samtools view -bS -s 0.9514 -@ $THREADS $INDIR/NA20129.nanopore.R10.hac.sorted.bam > $OUTDIR/NA20129.nanopore.R10.hac.70x.sorted.bam
samtools index -@ $THREADS $OUTDIR/NA20129.nanopore.R10.hac.70x.sorted.bam