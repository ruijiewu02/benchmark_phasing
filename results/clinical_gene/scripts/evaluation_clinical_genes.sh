### PIE evaluation on CMRG genes with 2473538 max gene distance no sqrt with phasing results from commonly used tools

source activate pie_no_sqrt

### PacBio HiFi
OUTDIR="../results/max_no_sqrt/PacBio_HiFi"
if [ ! -d "$OUTDIR" ]; then
  mkdir -p $OUTDIR
fi

for VCF in ../../snakemake_running/PacBio_HiFi/results.*.pacbio/final_phasing_output/*.pacbio.*.concated.variants.phased.vcf; do

    SAMPLE=$(basename $VCF .concated.variants.phased.vcf)
    echo $SAMPLE PIE clinical genes 2473538 max gene distance no sqrt running...;
 
    IFS='.' read -r -a SAMPLE_LST <<< $SAMPLE
    NAME=${SAMPLE_LST[0]}

    pie \
    --input ${VCF} --name ${SAMPLE} \
    --compare ../../../benchmarks/${NAME}.benchmark.vcf \
    --ref ../../../reference/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa.fai \
    --output ${OUTDIR}/${SAMPLE}.pie.2473538.clinical_genes \
    --threads 24 --block --no-sex -m 2473538 --bed ../GRCh38_CMRG_benchmark_gene_coordinates.bed \
    --verbose > ${OUTDIR}/${SAMPLE}.pie.2473538.clinical_genes.log 2>&1

done

### Nanopore R9

OUTDIR="../results/max_no_sqrt/Nanopore_R9"

if [ ! -d "$OUTDIR" ]; then
  mkdir -p $OUTDIR
fi

for VCF in ../../snakemake_running/Nanopore_R9_*/results.*.nanopore.R9.*/final_phasing_output/*.nanopore.R9.*.concated.variants.phased.vcf; do

    SAMPLE=$(basename $VCF .concated.variants.phased.vcf)
    echo $SAMPLE PIE clinical genes 2473538 max gene distance no sqrt running...;

    IFS='.' read -r -a SAMPLE_LST <<< $SAMPLE
    NAME=${SAMPLE_LST[0]}

    pie \
    --input ${VCF} --name ${SAMPLE} \
    --compare ../../../benchmarks/${NAME}.benchmark.vcf \
    --ref ../../../reference/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa.fai \
    --output ${OUTDIR}/${SAMPLE}.pie.2473538.clinical_genes \
    --threads 24 --block --no-sex -m 2473538 --bed ../GRCh38_CMRG_benchmark_gene_coordinates.bed \
    --verbose > ${OUTDIR}/${SAMPLE}.pie.2473538.clinical_genes.log 2>&1

done

### Nanopore R10

OUTDIR="../results/max_no_sqrt/Nanopore_R10"

if [ ! -d "$OUTDIR" ]; then
  mkdir -p $OUTDIR
fi

for VCF in ../../snakemake_running/Nanopore_R10_*/results.*.nanopore.R10.*/final_phasing_output/*.nanopore.R10.*.concated.variants.phased.vcf; do

    SAMPLE=$(basename $VCF .concated.variants.phased.vcf)
    echo $SAMPLE PIE clinical genes 2473538 max gene distance no sqrt running...;

    IFS='.' read -r -a SAMPLE_LST <<< $SAMPLE
    NAME=${SAMPLE_LST[0]}

    pie \
    --input ${VCF} --name ${SAMPLE} \
    --compare ../../../benchmarks/${NAME}.benchmark.vcf \
    --ref ../../../reference/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa.fai \
    --output ${OUTDIR}/${SAMPLE}.pie.2473538.clinical_genes \
    --threads 24 --block --no-sex -m 2473538 --bed ../GRCh38_CMRG_benchmark_gene_coordinates.bed \
    --verbose > ${OUTDIR}/${SAMPLE}.pie.2473538.clinical_genes.log 2>&1

done


conda deactivate