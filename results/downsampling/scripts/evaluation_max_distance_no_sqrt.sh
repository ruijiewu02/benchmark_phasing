### This scripts is used to run the evaluation for three individuals in different platforms. (no sqrt)

source activate pie_no_sqrt
### PacBio HiFi (HG02723)

OUTDIR="../results/evaluation/max_no_sqrt/HG02723"
if [ ! -d "$OUTDIR" ]; then
  mkdir -p $OUTDIR
fi

INDIR=../results/snakemake_running/HG02723/results.*.pacbio.*/final_phasing_output/*.pacbio.*.concated.variants.phased.vcf;

for VCF in $INDIR; do 
    
    SAMPLE=$(basename $VCF .concated.variants.phased.vcf);
    echo $SAMPLE PIE 2473538 max gene distance no sqrt only snps running...;

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

### Nanopore R9 (HG00733)
OUTDIR="../results/evaluation/max_no_sqrt/HG00733"
if [ ! -d "$OUTDIR" ]; then
    mkdir -p $OUTDIR
fi

INDIR=../results/snakemake_running/HG00733/results.*.nanopore.R9.*/final_phasing_output/*.nanopore.R9.*.concated.variants.phased.vcf;

for VCF in $INDIR; do 
    
    SAMPLE=$(basename $VCF .concated.variants.phased.vcf);
    echo $SAMPLE PIE 2473538 max gene distance no sqrt only snps running...;

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

### Nanopore R10 (NA20129)
OUTDIR="../results/evaluation/max_no_sqrt/NA20129"
if [ ! -d "$OUTDIR" ]; then
    mkdir -p $OUTDIR
fi

INDIR=../results/snakemake_running/NA20129/results.*.nanopore.R10.*/final_phasing_output/*.nanopore.R10.*.concated.variants.phased.vcf;

for VCF in $INDIR; do 
    
    SAMPLE=$(basename $VCF .concated.variants.phased.vcf);
    echo $SAMPLE PIE 2473538 max gene distance no sqrt only snps running...;

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