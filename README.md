# *This repository introduces the data analysis workflow of Phasing Evaluation.*

## *1. Prepare your working environment with conda and download the datasets*

*First, you should keep your working environment with conda.*
*Next, you should download the benchmarking datasets.*

## *2. Data pre-process of raw signal*

### *Transfer the downloaded signal data to `fastq` format.*

### *2.1 PacBio HiFi*

#### *2.1.1 `ccs.bam` transfer and concat to `fastq.gz`*
```sh
for i in ${PATH}; do

    o=${i##*/}
    t=${o%.ccs*}

    echo "Processing file: $o"
    echo "Output will be: $t.fastq.gz"

    samtools fastq $i -@ 8 | bgzip > ${PATH}/$t.fastq.gz

done
```

#### *2.1.2 concat `fastq.gz`*
```sh
fastcat ${PATH}/*.fastq.gz -f ${PATH}/summary.txt | bgzip > ${PATH}/data/${sample}.pacbio.fastq.gz &
```

### *2.2 Nanopore R9 and R10*

### *2.2.1 basecalling for `fast5`*

#### *2.2.1.1 `hdf5` conda env create*
```sh
conda create -n hdf5-env
conda activate hdf5-env
conda install -c anaconda hdf5
```

#### *2.2.1.2 manually inspect the output of `fast5`*
```sh
h5dump ${FAST5_FILE} | head -n 100000 | less
```

#### *2.2.1.3 look for `ATTRIBUTE "flowcell_type"`, `ATTRIBUTE "sequencing_kit"`, and `ATTRIBUTE "exp_script_name"`* 
#### *example:*
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

#### *2.2.1.4 Guppy Basecaller*
#### *example:*
```
config: dna_r9.4.1_450bps_sup_prom.cfg (R9 sup)
```

```sh
nohup ${absolute_path_of_guppy_basecaller}/ont-guppy-6.5.7/bin/guppy_basecaller \
-r -i ${PATH} -s ${PATH}/sup/basecalling_sup/ \
-c dna_r9.4.1_450bps_sup_prom.cfg -x cuda:0,1 &
```

#### *2.2.1.5 `fastq` to `fastq.gz`*
```sh
nohup fastcat $PATH/hac/bascalling_sup/pass/*.fastq | bgzip > $PATH/data/${sample}.nanopore.R9.fastq.gz &
```

### *2.2.2 basecalling for `pod5`*
```
null now
```



## *2. Use snakemake to deal with the upstream workflows of haplotype phasing*

## *3. Use PIE to conduct phasing evaluation of different platforms*

## *4. Use PIE to condcut phasing evaluation at specific regions*

## *5. Down-sampling process*
