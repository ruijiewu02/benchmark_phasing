# mapping based variants phasing using WhatsHap (concat + phasing)
rule WhatsHap_variants_concat: 
    input: 
        filtered_small_variants_file="{outdir}/results.{sample}/04_bcftools_small_variants_filtering/{sample}.filtered.small.variants.vcf", 
        filtered_structural_variants_file="{outdir}/results.{sample}/06_bash_structural_variants_filtering/{sample}.filtered.structural.variants.vcf"
    output: 
        bgzip_filtered_small_variants_file="{outdir}/results.{sample}/07_01_WhatsHap_variants_concat/{sample}.filtered.small.variants.vcf.gz", 
        bgzip_filtered_structural_variants_file="{outdir}/results.{sample}/07_01_WhatsHap_variants_concat/{sample}.filtered.structural.variants.vcf.gz", 
        temp_reheader_structural_variants_file="{outdir}/results.{sample}/07_01_WhatsHap_variants_concat/{sample}.temp.reheader.structural.variants.vcf.gz", 
        concated_variants_file="{outdir}/results.{sample}/07_01_WhatsHap_variants_concat/{sample}.concated.variants.vcf"
    message: 
        "Cat small variants and structural variants together as input for WhatsHap."
    conda: 
        "../envs/04_bcftools_small_variants_filtering.yaml"
    shell: 
        """
        bgzip -c {input.filtered_small_variants_file} > {output.bgzip_filtered_small_variants_file}
        bcftools index -t {output.bgzip_filtered_small_variants_file}
        bgzip -c {input.filtered_structural_variants_file} > {output.bgzip_filtered_structural_variants_file}
        bcftools reheader -s sample.txt -o {output.temp_reheader_structural_variants_file} {output.bgzip_filtered_structural_variants_file}
        bcftools index -t {output.temp_reheader_structural_variants_file}
        bcftools concat {output.bgzip_filtered_small_variants_file} {output.temp_reheader_structural_variants_file} -a > {output.concated_variants_file}
        """

rule WhatsHap_variants_phasing: 
    input: 
        sorted_bamfile="{outdir}/results.{sample}/02_samtools_samfile_process/{sample}.sorted.bam", 
        concated_variants_file="{outdir}/results.{sample}/07_01_WhatsHap_variants_concat/{sample}.concated.variants.vcf", 
        reference=reference
    output: 
        whatshap_phased_variants_file="{outdir}/results.{sample}/07_02_WhatsHap_variants_phasing/{sample}.WhatsHap.concated.variants.phased.vcf"
    message: 
        "WhatsHap Algorithm Phasing Variants Starts."
    log: 
        "{outdir}/results.{sample}/07_02_WhatsHap_variants_phasing/{sample}.WhatsHap.variants.phasing.log"
    benchmark: 
        "{outdir}/results.{sample}/benchmarks/{sample}.WhatsHap.variants.phasing.txt"
    conda: 
        "../envs/WhatsHap.yaml"
    shell: 
        """
        whatshap phase --output {output.whatshap_phased_variants_file} --reference {input.reference} \
        --ignore-read-groups {input.concated_variants_file} {input.sorted_bamfile} > {log} 2>&1 
        """

# mapping based variants phasing using HapCUT2 (phasing + concat)
rule HapCUT2_variants_phasing: 
    input: 
        sorted_bamfile="{outdir}/results.{sample}/02_samtools_samfile_process/{sample}.sorted.bam", 
        filtered_small_variants_file="{outdir}/results.{sample}/04_bcftools_small_variants_filtering/{sample}.filtered.small.variants.vcf", 
        reference=reference
    output: 
        hapcut2_phased_small_variants_file="{outdir}/results.{sample}/08_01_HapCUT2_variants_phasing/{sample}.HapCUT2.small.variants.phased.vcf"
    message: 
        "Phasing only small variants using HapCUT2."
    log: 
        "{outdir}/results.{sample}/08_01_HapCUT2_variants_phasing/{sample}.HapCUT2.variants.phasing.log"
    benchmark: 
        "{outdir}/results.{sample}/benchmarks/{sample}.HapCUT2.variants.phasing.txt"
    params: 
        extractHAIRS_fragments_file="{outdir}/results.{sample}/08_01_HapCUT2_variants_phasing/{sample}.fragments.file", 
        extractHAIRS_preset=config["extractHAIRS_PRESET"], 
        HapCUT2_output_prefix="{outdir}/results.{sample}/08_01_HapCUT2_variants_phasing/{sample}.HapCUT2.small.variants",
    conda: 
        "../envs/HapCUT2.yaml"
    shell: 
        """
        extractHAIRS --bam {input.sorted_bamfile} --VCF {input.filtered_small_variants_file} \
        --out {params.extractHAIRS_fragments_file} {params.extractHAIRS_preset} 1 \
        --ref {input.reference} --indels 1 --triallelic 1 > {log} 2>&1
        HAPCUT2 --fragments {params.extractHAIRS_fragments_file} --VCF {input.filtered_small_variants_file} \
        --output {params.HapCUT2_output_prefix} >> {log} 2>&1
        mv {params.HapCUT2_output_prefix}.phased.VCF {output.hapcut2_phased_small_variants_file}
        """

rule HapCUT2_variants_concat: 
    input: 
        phased_small_variants_file="{outdir}/results.{sample}/08_01_HapCUT2_variants_phasing/{sample}.HapCUT2.small.variants.phased.vcf", 
        filtered_structural_variants_file="{outdir}/results.{sample}/06_bash_structural_variants_filtering/{sample}.filtered.structural.variants.vcf"
    output: 
        bgzip_phased_small_variants_file="{outdir}/results.{sample}/08_02_HapCUT2_variants_concat/{sample}.HapCUT2.small.variants.phased.vcf.gz", 
        bgzip_filtered_structural_variants_file="{outdir}/results.{sample}/08_02_HapCUT2_variants_concat/{sample}.filtered.structural.variants.vcf.gz", 
        temp_reheader_structural_variants_file="{outdir}/results.{sample}/08_02_HapCUT2_variants_concat/{sample}.temp.reheader.structural.vcf.gz", 
        concated_variants_file="{outdir}/results.{sample}/08_02_HapCUT2_variants_concat/{sample}.HapCUT2.concated.variants.vcf"
    message: 
        "Cat phased small variants file and unphased atructural file together."
    conda: 
        "../envs/04_bcftools_small_variants_filtering.yaml"
    shell: 
        """
        bgzip -c {input.phased_small_variants_file} > {output.bgzip_phased_small_variants_file}
        bcftools index -t {output.bgzip_phased_small_variants_file}
        bgzip -c {input.filtered_structural_variants_file} > {output.bgzip_filtered_structural_variants_file}
        bcftools reheader -s  sample.txt -o {output.temp_reheader_structural_variants_file} {output.bgzip_filtered_structural_variants_file}
        bcftools index -t {output.temp_reheader_structural_variants_file}
        bcftools concat {output.bgzip_phased_small_variants_file} {output.temp_reheader_structural_variants_file} -a > {output.concated_variants_file}
        """

# mapping based variants phasing using Margin. (concat + cophasing)
rule Margin_variants_concat: 
    input: 
        filtered_small_variants_file="{outdir}/results.{sample}/04_bcftools_small_variants_filtering/{sample}.filtered.small.variants.vcf", 
        filtered_structural_variants_file="{outdir}/results.{sample}/06_bash_structural_variants_filtering/{sample}.filtered.structural.variants.vcf"
    output: 
        bgzip_filtered_small_variants_file="{outdir}/results.{sample}/09_01_Margin_variants_concat/{sample}.filtered.small.variants.vcf.gz", 
        bgzip_filtered_structural_variants_file="{outdir}/results.{sample}/09_01_Margin_variants_concat/{sample}.filtered.structural.variants.vcf.gz", 
        temp_reheader_structural_variants_file="{outdir}/results.{sample}/09_01_Margin_variants_concat/{sample}.temp.reheader.structural.variants.vcf.gz", 
        concated_variants_file="{outdir}/results.{sample}/09_01_Margin_variants_concat/{sample}.concated.variants.vcf"
    message: 
        "Cat small variants and structural variants together as input for Margin."
    conda: 
        "../envs/04_bcftools_small_variants_filtering.yaml"
    shell: 
        """
        bgzip -c {input.filtered_small_variants_file} > {output.bgzip_filtered_small_variants_file}
        bcftools index -t {output.bgzip_filtered_small_variants_file}
        bgzip -c {input.filtered_structural_variants_file} > {output.bgzip_filtered_structural_variants_file}
        bcftools reheader -s sample.txt -o {output.temp_reheader_structural_variants_file} {output.bgzip_filtered_structural_variants_file}
        bcftools index -t {output.temp_reheader_structural_variants_file}
        bcftools concat {output.bgzip_filtered_small_variants_file} {output.temp_reheader_structural_variants_file} -a > {output.concated_variants_file}
        """

rule Margin_variants_phasing: 
    input: 
        sorted_bamfile="{outdir}/results.{sample}/02_samtools_samfile_process/{sample}.sorted.bam", 
        concated_variants_file="{outdir}/results.{sample}/09_01_Margin_variants_concat/{sample}.concated.variants.vcf", 
        reference=reference
    output: 
        margin_phased_variants_file="{outdir}/results.{sample}/09_02_Margin_variants_phasing/{sample}.Margin.concated.variants.phased.vcf"
    message: 
        "Variants phasing using Margin phase."
    log: 
        "{outdir}/results.{sample}/09_02_Margin_variants_phasing/{sample}.Margin.variants.phasing.log"
    benchmark: 
        "{outdir}/results.{sample}/benchmarks/{sample}.Margin.variants.phasing.txt"
    params: 
        sorted_bamfile_1="{outdir}/results.{sample}/02_samtools_samfile_process", 
        sorted_bamfile_2="/input_sorted_bamfile", 
        concated_variants_file_1="{outdir}/results.{sample}/09_01_Margin_variants_concat", 
        concated_variants_file_2="/input_concated_variants_file", 
        reference_1=reference_prefix, 
        reference_2="/input_reference", 
        margin_model_prefix_1=config["Margin_MODEL_PREFIX"], 
        margin_model_prefix_2="/input_model_prefix", 
        margin_model=config["Margin_MODEL"], 
        output_prefix_1="{outdir}/results.{sample}/09_02_Margin_variants_phasing", 
        output_prefix_2="/output_prefix", 
        sample=sample
    threads: 16
    conda: 
        "../envs/Margin.yaml"
    shell: 
        """
        singularity exec -B {params.sorted_bamfile_1}:{params.sorted_bamfile_2} \
        -B {params.reference_1}:{params.reference_2} \
        -B {params.concated_variants_file_1}:{params.concated_variants_file_2} \
        -B {params.output_prefix_1}:{params.output_prefix_2} \
        -B {params.margin_model_prefix_1}:{params.margin_model_prefix_2} \
        margin_2.3.1.sif /home/margin-2.3.1/build/margin phase \
        {params.sorted_bamfile_2}/{params.sample}.sorted.bam \
        {params.reference_2}/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa \
        {params.concated_variants_file_2}/{params.sample}.concated.variants.vcf \
        {params.margin_model_prefix_2}/{params.margin_model} -t {threads} \
        -o {params.output_prefix_2}/{params.sample}.Margin.concated.variants > {log} 2>&1
        """

# mapping based variants phasing using LongPhase.(cophasing + concat)
rule LongPhase_variants_phasing: 
    input: 
        sorted_bamfile="{outdir}/results.{sample}/02_samtools_samfile_process/{sample}.sorted.bam", 
        filtered_small_variants_file="{outdir}/results.{sample}/04_bcftools_small_variants_filtering/{sample}.filtered.small.variants.vcf", 
        filtered_structural_variants_file="{outdir}/results.{sample}/06_bash_structural_variants_filtering/{sample}.filtered.structural.variants.vcf", 
        reference=reference
    output: 
        longphase_phased_small_variants_file="{outdir}/results.{sample}/10_01_LongPhase_variants_phasing/{sample}.LongPhase.variants.phased.vcf", 
        longphase_phased_structural_variants_file="{outdir}/results.{sample}/10_01_LongPhase_variants_phasing/{sample}.LongPhase.variants.phased_SV.vcf"
    message: 
        "Phasing small variants and structural variants together using LongPhase."
    log: 
        "{outdir}/results.{sample}/10_01_LongPhase_variants_phasing/{sample}.LongPhase.variants.phasing.log"
    benchmark: 
        "{outdir}/results.{sample}/benchmarks/{sample}.LongPhase.variants.phasing.txt"
    params: 
        LongPhase_preset=config["LongPhase_PRESET"], 
        output_prefix="{outdir}/results.{sample}/10_01_LongPhase_variants_phasing/{sample}.LongPhase.variants.phased"
    threads: 16
    conda: 
        "../envs/LongPhase.yaml"
    shell: 
        """
        longphase phase -s {input.filtered_small_variants_file} \
        -b {input.sorted_bamfile} -r {input.reference} \
        -t {threads} {params.LongPhase_preset} --indels \
        --sv-file={input.filtered_structural_variants_file} \
        -o {params.output_prefix} > {log} 2>&1
        """

rule LongPhase_variants_concat: 
    input: 
        longphase_phased_small_variants_file="{outdir}/results.{sample}/10_01_LongPhase_variants_phasing/{sample}.LongPhase.variants.phased.vcf", 
        longphase_phased_structural_variants_file="{outdir}/results.{sample}/10_01_LongPhase_variants_phasing/{sample}.LongPhase.variants.phased_SV.vcf"
    output: 
        bgzip_phased_small_variants_file="{outdir}/results.{sample}/10_02_LongPhase_variants_concat/{sample}.LongPhase.small.variants.phased.vcf.gz", 
        bgzip_phased_structural_variants_file="{outdir}/results.{sample}/10_02_LongPhase_variants_concat/{sample}.longPhase.structural.variants.phased_SV.vcf.gz", 
        temp_reheader_structural_variants_file="{outdir}/results.{sample}/10_02_LongPhase_variants_concat/{sample}.temp.reheader.structural.vcf.gz", 
        concated_phased_variants_file="{outdir}/results.{sample}/10_02_LongPhase_variants_concat/{sample}.LongPhase.concated.variants.vcf"
    message: 
        "Cat phased small variants file and structural file together phased by LongPhase."
    conda: 
        "../envs/04_bcftools_small_variants_filtering.yaml"
    shell: 
        """
        bgzip -c {input.longphase_phased_small_variants_file} > {output.bgzip_phased_small_variants_file}
        bcftools index -t {output.bgzip_phased_small_variants_file}
        bgzip -c {input.longphase_phased_structural_variants_file} > {output.bgzip_phased_structural_variants_file}
        bcftools reheader -s sample.txt -o {output.temp_reheader_structural_variants_file} {output.bgzip_phased_structural_variants_file}
        bcftools index -t {output.temp_reheader_structural_variants_file}
        bcftools concat {output.bgzip_phased_small_variants_file} {output.temp_reheader_structural_variants_file} -a > {output.concated_phased_variants_file}
        """

## mapping based variants phasing using HiPhase (cophasing + concat)

rule HiPhase_variants_compressed: 
    input: 
        filtered_small_variants_file="{outdir}/results.{sample}/04_bcftools_small_variants_filtering/{sample}.filtered.small.variants.vcf", 
        filtered_structural_variants_file="{outdir}/results.{sample}/06_bash_structural_variants_filtering/{sample}.filtered.structural.variants.vcf"
    output: 
        compressed_small_variants_file="{outdir}/results.{sample}/11_01_HiPhase_variants_compressed/{sample}.filtered.small.variants.vcf.gz", 
        compressed_small_variants_file_index="{outdir}/results.{sample}/11_01_HiPhase_variants_compressed/{sample}.filtered.small.variants.vcf.gz.tbi", 
        compressed_structural_variants_file="{outdir}/results.{sample}/11_01_HiPhase_variants_compressed/{sample}.filtered.structural.variants.vcf.gz", 
        reheader_structural_variants_file="{outdir}/results.{sample}/11_01_HiPhase_variants_compressed/{sample}.reheader.structural.variants.vcf.gz", 
        reheader_structural_variants_file_index="{outdir}/results.{sample}/11_01_HiPhase_variants_compressed/{sample}.reheader.structural.variants.vcf.gz.tbi"
    message: 
        "The input VCF of HiPhase must be compressed."
    conda: 
        "../envs/04_bcftools_small_variants_filtering.yaml"
    shell: 
        """
        bgzip -c {input.filtered_small_variants_file} > {output.compressed_small_variants_file}
        bcftools index -t {output.compressed_small_variants_file}
        bgzip -c {input.filtered_structural_variants_file} > {output.compressed_structural_variants_file}
        bcftools reheader -s sample.txt -o {output.reheader_structural_variants_file} {output.compressed_structural_variants_file}
        bcftools index -t {output.reheader_structural_variants_file}
        """

rule HiPhase_variants_phasing: 
    input: 
        sorted_bamfile="{outdir}/results.{sample}/02_samtools_samfile_process/{sample}.sorted.bam", 
        filtered_small_variants_file="{outdir}/results.{sample}/11_01_HiPhase_variants_compressed/{sample}.filtered.small.variants.vcf.gz", 
        filtered_structural_variants_file="{outdir}/results.{sample}/11_01_HiPhase_variants_compressed/{sample}.reheader.structural.variants.vcf.gz", 
        reference=reference
    output: 
        hiphase_phased_small_variants_file="{outdir}/results.{sample}/11_02_HiPhase_variants_phasing/{sample}.HiPhase.small.variants.phased.vcf.gz", 
        hiphase_phased_structural_variants_file="{outdir}/results.{sample}/11_02_HiPhase_variants_phasing/{sample}.HiPhase.structural.variants.phased.vcf.gz"
    message: 
        "Phasing small variants and structural variants using HiPhase."
    log: 
        "{outdir}/results.{sample}/11_02_HiPhase_variants_phasing/{sample}.HiPhase.variants.phasing.log"
    benchmark: 
        "{outdir}/results.{sample}/benchmarks/{sample}.HiPhase.variants.phasing.txt"
    threads: 16
    conda: 
        "../envs/HiPhase.yaml"
    shell: 
        """
        hiphase --bam {input.sorted_bamfile} --reference {input.reference} --ignore-read-groups \
        --vcf {input.filtered_small_variants_file} \
        --output-vcf {output.hiphase_phased_small_variants_file} \
        --vcf {input.filtered_structural_variants_file} \
        --output-vcf {output.hiphase_phased_structural_variants_file} \
        --threads {threads} > {log} 2>&1
        """

rule Hiphase_variants_concat: 
    input: 
        hiphase_phased_small_variants_file="{outdir}/results.{sample}/11_02_HiPhase_variants_phasing/{sample}.HiPhase.small.variants.phased.vcf.gz", 
        hiphase_phased_structural_variants_file="{outdir}/results.{sample}/11_02_HiPhase_variants_phasing/{sample}.HiPhase.structural.variants.phased.vcf.gz"
    output: 
        concated_phased_variants_file="{outdir}/results.{sample}/11_03_HiPhase_variants_concat/{sample}.HiPhase.concated.variants.phased.vcf"
    message: 
         "Cat phased small variants file and structural file together phased by HiPhase."
    conda: 
         "../envs/04_bcftools_small_variants_filtering.yaml"
    shell: 
        """
        bcftools concat {input.hiphase_phased_small_variants_file} {input.hiphase_phased_structural_variants_file} -a > {output.concated_phased_variants_file}
        """