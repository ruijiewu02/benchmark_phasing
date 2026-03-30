source activate pie

OUTDIR="../results/250kb/Nanopore_R10";

if [ ! -d $OUTDIR ]; then
    mkdir -p $OUTDIR;
fi

INDIR=../../snakemake_running/Nanopore_R10_*/results.*/final_phasing_output/*.nanopore.R10.*.concated.variants.phased.vcf;

for VCF in $INDIR; do 
    
    SAMPLE=$(basename $VCF .concated.variants.phased.vcf);
    echo $SAMPLE PIE 250kb Running...;

    IFS='.' read -r -a SAMPLE_DIC <<< $SAMPLE
    NAME=${SAMPLE_DIC[0]}

    echo $NAME;

    pie \
    --input $VCF --name $SAMPLE \
    --compare ../../../benchmarks/$NAME.benchmark.vcf \
    --ref ../../../reference/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa.fai \
    --output $OUTDIR/$SAMPLE.pie \
    --threads 24 --block --no-sex \
    --verbose > $OUTDIR/$SAMPLE.pie.log 2>&1

done

conda deactivate