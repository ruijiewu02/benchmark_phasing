## This script is used to download the truth variants information for benchmarks.

## For HG002 and HG005
# https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG002_NA24385_son/NISTv4.2.1/GRCh38/SupplementaryFiles/HG002_GRCh38_1_22_v4.2.1_benchmark_hifiasm_v11_phasetransfer.vcf.gz
wget -P ../benchmarks https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG002_NA24385_son/NISTv4.2.1/GRCh38/SupplementaryFiles/HG002_GRCh38_1_22_v4.2.1_benchmark_hifiasm_v11_phasetransfer.vcf.gz
gunzip -c ../benchmarks HG002_GRCh38_1_22_v4.2.1_benchmark_hifiasm_v11_phasetransfer.vcf.gz > ../benchmarks/HG002.benchmark.vcf

# https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/ChineseTrio/HG005_NA24631_son/NISTv4.2.1/GRCh38/SupplementaryFiles/HG005_GRCh38_1_22_v4.2.1_highconf_hifiasm_v11_phasetransfer.vcf.gz
wget -P ../benchmarks https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/ChineseTrio/HG005_NA24631_son/NISTv4.2.1/GRCh38/SupplementaryFiles/HG005_GRCh38_1_22_v4.2.1_highconf_hifiasm_v11_phasetransfer.vcf.gz
gunzip -c ../benchmarks HG005_GRCh38_1_22_v4.2.1_highconf_hifiasm_v11_phasetransfer.vcf.gz > ..benchmarks/HG005.benchmark.vcf

## For other samples
sample_list=(HG00733 HG01109 HG01243 HG02055 HG02080
             HG02109 HG02145 HG02723 HG03098 HG03492
             HG02818 HG03486 NA18906 NA19240 NA20129 NA21309)

for sample in ${sample_list[@]}; do
    aws --no-sign-request s3 sync s3://human-pangenomics/working/HPRC_PLUS/$sample/assemblies/year1_f1_assembly_v2_genbank/assembly_qc/dipcall/ ../benchmarks --exclude "*" --include "*.f1_assembly_v2_genbank.dip.vcf.gz"
    gunzip -c ..benchmarks/$sample.f1_assembly_v2_genbank.dip.vcf.gz > ../benchmarks/$sample.benchmark.vcf
    echo "$sample benchmarks downloads successfully!"
done
