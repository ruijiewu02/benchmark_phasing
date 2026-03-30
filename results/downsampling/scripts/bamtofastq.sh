### This script is used to convert bam files to fastq files for three individuals in different platforms
THREADS=48

### PacBio HiFi (HG02723)
samtools fastq -@ $THREADS ../data/HG02723/HG02723.pacbio.10x.sorted.bam | bgzip -@ $THREADS > ../data/HG02723/HG02723.pacbio.10x.fastq.gz
samtools fastq -@ $THREADS ../data/HG02723/HG02723.pacbio.20x.sorted.bam | bgzip -@ $THREADS > ../data/HG02723/HG02723.pacbio.20x.fastq.gz
samtools fastq -@ $THREADS ../data/HG02723/HG02723.pacbio.30x.sorted.bam | bgzip -@ $THREADS > ../data/HG02723/HG02723.pacbio.30x.fastq.gz
samtools fastq -@ $THREADS ../data/HG02723/HG02723.pacbio.40x.sorted.bam | bgzip -@ $THREADS > ../data/HG02723/HG02723.pacbio.40x.fastq.gz

### Nanopore R9 (HG00733)
samtools fastq -@ $THREADS ../data/HG00733/HG00733.nanopore.R9.hac.10x.sorted.bam | bgzip -@ $THREADS > ../data/HG00733/HG00733.nanopore.R9.hac.10x.fastq.gz
samtools fastq -@ $THREADS ../data/HG00733/HG00733.nanopore.R9.hac.20x.sorted.bam | bgzip -@ $THREADS > ../data/HG00733/HG00733.nanopore.R9.hac.20x.fastq.gz
samtools fastq -@ $THREADS ../data/HG00733/HG00733.nanopore.R9.hac.30x.sorted.bam | bgzip -@ $THREADS > ../data/HG00733/HG00733.nanopore.R9.hac.30x.fastq.gz
samtools fastq -@ $THREADS ../data/HG00733/HG00733.nanopore.R9.hac.40x.sorted.bam | bgzip -@ $THREADS > ../data/HG00733/HG00733.nanopore.R9.hac.40x.fastq.gz
samtools fastq -@ $THREADS ../data/HG00733/HG00733.nanopore.R9.hac.50x.sorted.bam | bgzip -@ $THREADS > ../data/HG00733/HG00733.nanopore.R9.hac.50x.fastq.gz
samtools fastq -@ $THREADS ../data/HG00733/HG00733.nanopore.R9.hac.60x.sorted.bam | bgzip -@ $THREADS > ../data/HG00733/HG00733.nanopore.R9.hac.60x.fastq.gz

### Nanopore R10 (NA20129)
samtools fastq -@ $THREADS ../data/NA20129/NA20129.nanopore.R10.hac.10x.sorted.bam | bgzip -@ $THREADS > ../data/NA20129/NA20129.nanopore.R10.hac.10x.fastq.gz
samtools fastq -@ $THREADS ../data/NA20129/NA20129.nanopore.R10.hac.20x.sorted.bam | bgzip -@ $THREADS > ../data/NA20129/NA20129.nanopore.R10.hac.20x.fastq.gz
samtools fastq -@ $THREADS ../data/NA20129/NA20129.nanopore.R10.hac.30x.sorted.bam | bgzip -@ $THREADS > ../data/NA20129/NA20129.nanopore.R10.hac.30x.fastq.gz
samtools fastq -@ $THREADS ../data/NA20129/NA20129.nanopore.R10.hac.40x.sorted.bam | bgzip -@ $THREADS > ../data/NA20129/NA20129.nanopore.R10.hac.40x.fastq.gz
samtools fastq -@ $THREADS ../data/NA20129/NA20129.nanopore.R10.hac.50x.sorted.bam | bgzip -@ $THREADS > ../data/NA20129/NA20129.nanopore.R10.hac.50x.fastq.gz
samtools fastq -@ $THREADS ../data/NA20129/NA20129.nanopore.R10.hac.60x.sorted.bam | bgzip -@ $THREADS > ../data/NA20129/NA20129.nanopore.R10.hac.60x.fastq.gz
samtools fastq -@ $THREADS ../data/NA20129/NA20129.nanopore.R10.hac.70x.sorted.bam | bgzip -@ $THREADS > ../data/NA20129/NA20129.nanopore.R10.hac.70x.fastq.gz