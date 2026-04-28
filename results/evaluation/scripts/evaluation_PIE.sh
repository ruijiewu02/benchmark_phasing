source activate pie

### Part1: PacBio HiFi evaluation

OUTDIR="../results/PacBio_HiFi";

if [ ! -d $OUTDIR ]; then
    mkdir -p $OUTDIR;
fi

INDIR=../../snakemake_running/PacBio_HiFi/results.*/final_phasing_output/*.pacbio.*.concated.variants.phased.vcf;

for VCF in $INDIR; do 
    
    SAMPLE=$(basename $VCF .concated.variants.phased.vcf);
    echo $SAMPLE PIE 2473538 max gene distance no sqrt running...;

    IFS='.' read -r -a SAMPLE_DIC <<< $SAMPLE
    NAME=${SAMPLE_DIC[0]}

    pie \
    --input $VCF --name $SAMPLE \
    --compare ../../../benchmarks/$NAME.benchmark.vcf \
    --ref ../../../reference/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa.fai \
    --output $OUTDIR/$SAMPLE.pie.2473538 \
    --threads 24 --block --no-sex -m 2473538 \
    --verbose > $OUTDIR/$SAMPLE.pie.2473538.log 2>&1
done

### Part2: Nanopore R9 evaluation

OUTDIR="../results/Nanopore_R9";

if [ ! -d $OUTDIR ]; then
    mkdir -p $OUTDIR;
fi

INDIR=../../snakemake_running/Nanopore_R9_*/results.*/final_phasing_output/*.nanopore.R9.*.concated.variants.phased.vcf;

for VCF in $INDIR; do 
    
    SAMPLE=$(basename $VCF .concated.variants.phased.vcf);
    echo $SAMPLE PIE 2473538 max gene distance no sqrt running...;

    IFS='.' read -r -a SAMPLE_DIC <<< $SAMPLE
    NAME=${SAMPLE_DIC[0]}

    pie \
    --input $VCF --name $SAMPLE \
    --compare ../../../benchmarks/$NAME.benchmark.vcf \
    --ref ../../../reference/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa.fai \
    --output $OUTDIR/$SAMPLE.pie.2473538 \
    --threads 24 --block --no-sex -m 2473538 \
    --verbose > $OUTDIR/$SAMPLE.pie.2473538.log 2>&1

done

### Part3: Nanopore R10 evaluation

OUTDIR="../results/Nanopore_R10";

if [ ! -d $OUTDIR ]; then
    mkdir -p $OUTDIR;
fi

INDIR=../../snakemake_running/Nanopore_R10_*/results.*/final_phasing_output/*.nanopore.R10.*.concated.variants.phased.vcf;

for VCF in $INDIR; do 
    
    SAMPLE=$(basename $VCF .concated.variants.phased.vcf);
    echo $SAMPLE PIE 2473538 max gene distance no sqrt running...;

    IFS='.' read -r -a SAMPLE_DIC <<< $SAMPLE
    NAME=${SAMPLE_DIC[0]}

    pie \
    --input $VCF --name $SAMPLE \
    --compare ../../../benchmarks/$NAME.benchmark.vcf \
    --ref ../../../reference/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa.fai \
    --output $OUTDIR/$SAMPLE.pie.2473538 \
    --threads 24 --block --no-sex -m 2473538 \
    --verbose > $OUTDIR/$SAMPLE.pie.2473538.log 2>&1

done

conda deactivate
