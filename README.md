# This repository introduces the data analysis workflow of Phasing Evaluation.

## 1. Prepare your working environment with conda and download the datasets

First, you should keep your working environment with `conda`.

Next, you should download the benchmarking datasets. Details in `scripts/download_benchmarks.sh`.

## 2. Data pre-process of raw signal

You should transfer the downloaded signal data to `fastq` format.

### 2.1 PacBio HiFi datasets transfer

#### 2.1.1 `ccs.bam` transfer and concat to `fastq.gz`
```sh
for i in ${PATH}; do

    o=${i##*/}
    t=${o%.ccs*}

    echo "Processing file: $o"
    echo "Output will be: $t.fastq.gz"

    samtools fastq $i -@ 8 | bgzip > ${PATH}/$t.fastq.gz

done
```

#### 2.1.2 concat `fastq.gz`
```sh
fastcat ${PATH}/*.fastq.gz -f ${PATH}/summary.txt | bgzip > ${PATH}/data/${sample}.pacbio.fastq.gz
```

### 2.2 ONT R9 and R10

### 2.2.1 basecalling for `fast5` in R9

#### 2.2.1.1 `hdf5` conda env create
```sh
conda create -n hdf5-env
conda activate hdf5-env
conda install -c anaconda hdf5
```

#### 2.2.1.2 manually inspect the output of `fast5`
```sh
h5dump ${FAST5_FILE} | head -n 100000 | less
```

#### 2.2.1.3 look for `ATTRIBUTE "flowcell_type"`, `ATTRIBUTE "sequencing_kit"`, and `ATTRIBUTE "exp_script_name"` 
#### example:
```
ATTRIBUTE "sequencing_kit" {
DATATYPE H5T STRING (
	STRSIZE 11;
	STRPAD H5T_STR_NULLTERM;
	CSET H5T_CSET_ASCII;
	CTYPE H5T_C_S1;
	}
	DATASPACE  SCALAR
	DATA {
	(0):"sqk-lsk114"
	}
```

#### 2.2.1.4 Guppy Basecaller (Version 6.5.7)
#### example:
```
config: dna_r9.4.1_450bps_sup_prom.cfg (R9 sup)
```

```sh
${absolute_path_of_guppy_basecaller}/ont-guppy-6.5.7/bin/guppy_basecaller \
-r -i ${PATH} -s ${PATH}/sup/basecalling_sup/ \
-c dna_r9.4.1_450bps_sup_prom.cfg -x cuda:0,1
```

#### 2.2.1.5 `fastq` to `fastq.gz`
```sh
fastcat $PATH/hac/bascalling_sup/pass/*.fastq | bgzip > $PATH/data/${sample}.nanopore.R9.fastq.gz
```

## 3. Use `snakemake` to deal with the upstream workflows of haplotype phasing

### 3.1 environment perparation
```sh
conda create -n snakemake-env -c conda-forge -c bioconda snakemake singularity=3.8.6
```

### 3.2 command line
for PacBio HiFi dataset and ONT dataset, we prepare different scripts to execute. Details in `scripts` folder.

The output result file structure is as following.

For nanopore dataset, no `HiPhase` associated file structure.
```
benchmark_phasing/results/snakemake_running/PacBio_HiFi/results.HG00733.pacbio/
├── 01_minimap2_sequence_alignment
├── 02_samtools_samfile_process
├── 03_clair3_small_variants_calling
├── 04_bcftools_small_variants_filtering
├── 05_cutesv_structural_variants_calling
├── 06_bash_structural_variants_filtering
├── 07_01_WhatsHap_variants_concat
├── 07_02_WhatsHap_variants_phasing
├── 08_01_HapCUT2_variants_phasing
├── 08_02_HapCUT2_variants_concat
├── 09_01_Margin_variants_concat
├── 09_02_Margin_variants_phasing
├── 10_01_LongPhase_variants_phasing
├── 10_02_LongPhase_variants_concat
├── 11_01_HiPhase_variants_compressed
├── 11_02_HiPhase_variants_phasing
├── 11_03_HiPhase_variants_concat
├── benchmarks
└── final_phasing_output
```

## 3. Use PIE to conduct phasing evaluation of different platforms

After sequence alignment, variant calling (SNP, INDEL, and SV), and haplotype phasing, each phasing algorithm contains a phased VCF file.

The phasing evaluation is performed with phased VCF file, the ground-truth VCF file, and a reference genome FASTA/FAI file.

The detailed execution document is under the `results/evaluation/scripts` folder.

## 4. Use PIE to condcut phasing evaluation at specific regions

The phasing evaluation workflow not only includes the genome-wide level benchmarking, but also includes the region-specific level benchmarking.

This analysis is achieved by PIE's region-specific phasing evaluation function.

The detailed execution document is under the `results/clinical_gene/scirpts` folder.

## 5. Down-sampling process

We performed down-sampling experiments to check the impact of sequencing depth.

The detailed excution document is under the `results/downsamling/scripts` folder.
