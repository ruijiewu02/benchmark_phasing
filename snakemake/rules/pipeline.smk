# Long reads alignment. 
rule minimap2_sequence_alignment: 
    input: 
        fastq=config["FASTQ"], 
        reference=reference
    output: 
        samfile=temp("{outdir}/results.{sample}/01_minimap2_sequence_alignment/{sample}.sam")
    message: 
        "Mapping sequence data to reference genome."
    log: 
        "{outdir}/results.{sample}/01_minimap2_sequence_alignment/{sample}.minimap2.sequence.alignment.log"
    threads: 48
    params: 
        minimap2_preset=config["MINIMAP2_PRESET"]
    conda: 
        "../envs/01_minimap2_sequence_alignment.yaml"
    shell: 
        """
        minimap2 -ax {params.minimap2_preset} -L -y -t {threads} \
        -o {output.samfile} {input.reference} {input.fastq} > {log} 2>&1
        """

# Samfile processing using samtools. 
rule samtools_samfile_process: 
    input: 
        samfile="{outdir}/results.{sample}/01_minimap2_sequence_alignment/{sample}.sam"
    output: 
        bamfile=temp("{outdir}/results.{sample}/02_samtools_samfile_process/{sample}.bam"), 
        sorted_bamfile="{outdir}/results.{sample}/02_samtools_samfile_process/{sample}.sorted.bam", 
        sorted_bamfile_idx="{outdir}/results.{sample}/02_samtools_samfile_process/{sample}.sorted.bam.bai"
    message: 
        "sam format file process using samtools."
    threads: 48
    conda: 
        "../envs/02_samtools_samfile_process.yaml"
    shell: 
        """
        samtools view -bh -@ {threads} -S {input.samfile} -o {output.bamfile}
        samtools sort -@ {threads} -o {output.sorted_bamfile} {output.bamfile}
        samtools index -@ {threads} {output.sorted_bamfile}
        """

# small variants calling using Clair3.
rule clair3_small_variants_calling: 
    input: 
        sorted_bamfile="{outdir}/results.{sample}/02_samtools_samfile_process/{sample}.sorted.bam", 
        reference=reference
    output: 
        small_variants_file="{outdir}/results.{sample}/03_clair3_small_variants_calling/{sample}.small.variants.vcf.gz"
    message: 
        "Small variants calling using Clair3."
    log: 
        "{outdir}/results.{sample}/03_clair3_small_variants_calling/{sample}.clair3.small.variants.calling.log"
    threads: 48
    params: 
        clair3_preset_p=config["CLAIR3_PRESET_P"], 
        clair3_preset_m=config["CLAIR3_PRESET_M"], 
        clair3_preset_o="{outdir}/results.{sample}/03_clair3_small_variants_calling"
    conda: 
        "../envs/03_clair3_small_variants_calling.yaml"
    shell: 
        """
        run_clair3.sh -b {input.sorted_bamfile} -f {input.reference} -t {threads} \
        -p {params.clair3_preset_p} -m {params.clair3_preset_m} -o {params.clair3_preset_o} > {log} 2>&1
        cp {params.clair3_preset_o}/merge_output.vcf.gz {output.small_variants_file}
        """

# small variants filter using bcftools
rule bcftools_small_variants_filtering: 
    input: 
        small_variants_file="{outdir}/results.{sample}/03_clair3_small_variants_calling/{sample}.small.variants.vcf.gz"
    output: 
        filtered_small_variants_file="{outdir}/results.{sample}/04_bcftools_small_variants_filtering/{sample}.filtered.small.variants.vcf"
    message: 
        "Filtering small variants using bcftools."
    conda: 
        "../envs/04_bcftools_small_variants_filtering.yaml"
    shell: 
        """
        bcftools filter -i "FILTER='PASS'" {input.small_variants_file} -o {output.filtered_small_variants_file}
        """

# structural variants calling using cuteSV.
rule cutesv_structural_variants_calling: 
    input: 
        sorted_bamfile="{outdir}/results.{sample}/02_samtools_samfile_process/{sample}.sorted.bam", 
        reference=reference
    output: 
        structural_variants_file="{outdir}/results.{sample}/05_cutesv_structural_variants_calling/{sample}.structural.variants.vcf"
    message: 
        "Structural variants calling using cuteSV."
    log: 
        "{outdir}/results.{sample}/05_cutesv_structural_variants_calling/{sample}.cutesv.structural.variants.calling.log"
    threads: 48
    params: 
        output_path=config["OUTDIR"], 
        max_cluster_bias_INS=config["MAX_CLUSTER_BIAS_INS"],
        diff_ratio_merging_INS=config["DIFF_RATIO_MERGING_INS"], 
        max_cluster_bias_DEL=config["MAX_CLUSTER_BIAS_INS"], 
        diff_ratio_merging_DEL=config["DIFF_RATIO_MERGING_INS"]
    conda: 
        "../envs/05_cutesv_structural_variants_calling.yaml"
    shell: 
        """
        cuteSV {input.sorted_bamfile} {input.reference} {output.structural_variants_file} {params.output_path}/results.{sample}/05_cutesv_structural_variants_calling/ \
        --report_readid --genotype \
        --max_cluster_bias_INS {params.max_cluster_bias_INS} \
        --diff_ratio_merging_INS {params.diff_ratio_merging_INS} \
        --max_cluster_bias_DEL {params.max_cluster_bias_DEL} \
        --diff_ratio_merging_INS {params.diff_ratio_merging_DEL} \
        -t {threads} > {log} 2>&1
        """

# structural variants filtering.
rule bash_structural_variants_filtering: 
    input: 
        structural_variants_file="{outdir}/results.{sample}/05_cutesv_structural_variants_calling/{sample}.structural.variants.vcf"
    output: 
        filterd_structural_variants_file="{outdir}/results.{sample}/06_bash_structural_variants_filtering/{sample}.filtered.structural.variants.vcf"
    message: 
        "Structural variants filtering."
    shell: 
        """
        cat {input.structural_variants_file} | awk '($1 ~ /^#/ || ($1 ~ /^chr([1-9]|1[0-9]|2[0-2]|X|Y)$/ && $7 == "PASS" && $10 !~ /^\.\/\./))' > {output.filterd_structural_variants_file}
        """
