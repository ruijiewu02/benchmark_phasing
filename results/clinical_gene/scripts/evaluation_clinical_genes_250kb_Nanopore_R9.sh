source activate pie

### PIE evaluation on CMRG genes with 250kb distance threshold with phasing results from commonly used tools on Nanopore R9 data

for VCF in ../../snakemake_running/Nanopore_R9_*/results.*.nanopore.R9.*/final_phasing_output/*.nanopore.R9.*.concated.variants.phased.vcf; do

    SAMPLE=$(basename $VCF .concated.variants.phased.vcf)
    echo $SAMPLE PIE CMRG genes 250kb running
 
    IFS='.' read -r -a SAMPLE_LST <<< $SAMPLE
    NAME=${SAMPLE_LST[0]}
    echo $NAME

    pie \
    --input ${VCF} --name ${SAMPLE} \
    --compare ../../../benchmarks/${NAME}.benchmark.vcf \
    --ref ../../../reference/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa.fai \
    --output ../results/250kb/Nanopore_R9/${SAMPLE}.pie.CMRG \
    --threads 24 --block --no-sex --bed ../GRCh38_CMRG_benchmark_gene_coordinates.bed \
    --verbose > ../results/250kb/Nanopore_R9/${SAMPLE}.pie.CMRG.log 2>&1

done

conda deactivate