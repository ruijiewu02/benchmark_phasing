source activate whatshap-env


OUTDIR="../results/max_no_sqrt/PacBio_HiFi_whatshap_compare";

if [ ! -d $OUTDIR ]; then
    mkdir -p $OUTDIR;
fi

INDIR=../../snakemake_running/PacBio_HiFi/results.*/final_phasing_output/*.pacbio.*.concated.variants.phased.vcf;

for VCF in $INDIR; do 
    
    SAMPLE=$(basename $VCF .concated.variants.phased.vcf);
    echo $SAMPLE PIE 2473538 max gene distance no sqrt running...;

    IFS='.' read -r -a SAMPLE_DIC <<< $SAMPLE
    NAME=${SAMPLE_DIC[0]}

    whatshap compare \
    --names $NAME.truth,$SAMPLE --tsv-pairwise $OUTDIR/$SAMPLE.pie.2473538.whatshap.compare.tsv \
    --ignore-sample-name \
     ../../../benchmarks/$NAME.benchmark.vcf $VCF \
    > $OUTDIR/$SAMPLE.pie.2473538.whatshap.compare.log 2>&1
done