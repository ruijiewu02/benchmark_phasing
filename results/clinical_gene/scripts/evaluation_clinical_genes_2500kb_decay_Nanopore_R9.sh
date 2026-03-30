### PIE evaluation on CMRG genes with 2500kb distance threshold with phasing results from commonly used tools on Nanopore R9 data
source activate pie-11

OUTDIR="../results/2500kb_decay/Nanopore_R9"

if [ ! -d "$OUTDIR" ]; then
  mkdir -p $OUTDIR
fi

for VCF in ../../snakemake_running/Nanopore_R9_*/results.*.nanopore.R9.*/final_phasing_output/*.nanopore.R9.*.concated.variants.phased.vcf; do

    SAMPLE=$(basename $VCF .concated.variants.phased.vcf)
    echo $SAMPLE PIE CMRG genes 2500kb decay running

    IFS='.' read -r -a SAMPLE_LST <<< $SAMPLE
    NAME=${SAMPLE_LST[0]}
    echo $NAME

    pie \
    --input ${VCF} --name ${SAMPLE} \
    --compare ../../../benchmarks/${NAME}.benchmark.vcf \
    --ref ../../../reference/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa.fai \
    --output ${OUTDIR}/${SAMPLE}.pie.2500kb.CMRG \
    --threads 24 --block --no-sex -m 25000000 --bed ../GRCh38_CMRG_benchmark_gene_coordinates.bed \
    --verbose > ${OUTDIR}/${SAMPLE}.pie.2500kb.CMRG.log 2>&1

done

conda deactivate