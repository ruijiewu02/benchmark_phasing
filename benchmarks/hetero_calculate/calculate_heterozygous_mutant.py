## This script is used to calculate the mutation sites counts of heterozygotes in VCF format file.

import re
import argparse
import vcf
from collections import Counter
import multiprocessing
import time
import pandas as pd

start_time = time.time()

parser = argparse.ArgumentParser(description='Calculate the mutation sites counts of heterozygotes.')
parser.add_argument('--query', help='the query variants file')
#parser.add_argument('--truth', nargs='+', help='the truth variants file')
parser.add_argument('--output', help='the output results')

args = parser.parse_args()
#truth = args.truth
query = args.query
output = args.output

print(args)
def parse_variants_file(VCF):
    #VCF = VCF[0]
    name = VCF.split("/")[-1]
    name = name.split(".")[0]

    vcf_reader = vcf.Reader(open(VCF, 'r'))
    sites = [['chrom', 'pos', 'genotype', 'phaseset']]
    
    #genotypes = []
    #phaseSet = []

    pattern = r'chr[1-9]|chr[1-2][0-2]'

    for record in vcf_reader:

        if re.match(pattern, record.CHROM):

            chrom = record.CHROM
            pos = record.POS
        
            for sample in record.samples:
                genotype = sample['GT']
                #genotypes.append(genotype)
                if genotype in ['0|1', '1|0', '1|2', '2|1']:
                #if 'PS' in sample.data._fields:
                    #genotype = sample['GT']
                    if 'PS' in sample.data._fields:
                        phase = sample['PS']
                        #genotype = sample['GT']

                    #if genotype in ['0|1', '1|0', '1|2', '2|1']:

                        #phaseSet.append([chrom, phase])
                        #genotypes.append([pos, genotype])
                        sites.append([chrom, pos, genotype, phase])

    return(name, sites)

def get_block(sites):

    phaseSet = []

    site0 = sites[0]
    chrom0 = site0[0]
    start0 = site0[1]
    phase0 = site0[3]

    for site in sites[1:]:
        chrom = site[0]
        pos = site[1]
        #genotype = site[2]
        phase = site[3]

        if (chrom == chrom0) and (phase == phase0):
            continue
        else:
            length = pos - start0
            phaseSet.append([chrom, start0, pos, length])
            chrom0 = chrom
            phase0 = phase
    return(phaseSet[0:10])



def intersection(truth, query): 
    
    truth_block = parse_block(truth)
    query_block = parse_block(query)

if __name__ == "__main__":
    #sites = parse_variants_file(query)
    #print(get_block(sites))
    
    results = parse_variants_file(query)

    '''
    with multiprocessing.Pool(processes=len(query)) as pool:
        results = pool.map(parse_variants_file, query)
    '''
    #print(results)
    '''
        with open('het.variants.txt', 'w') as fo:
            for result in results:
                fo.write(("\t").join(result) + "\n")

    '''
    name = results[0]
    sites = results[1]
    blocks = pd.DataFrame(sites[1:], columns=sites[0])

    #print(blocks)

    bed = blocks.groupby(["chrom", "phaseset"]).agg(
        start_position=("pos", "min"),
        end_position=("pos", "max")
        ).reset_index()

    bed["block_length"] = bed["end_position"] - bed["start_position"]

    bed.to_csv(f'{output}.tsv', sep = '\t')
    #print(bed)
    '''
        output = ["\t".join(['name', 'hetero', 'double_hetero', 'percent'])]
        
        for result in results: 
            print(result)

            name = result[0]
            counter = result[1]

            double_hetero = counter["1|2"] + counter["2|1"]
            hetero = counter["1|0"] + counter["0|1"] + double_hetero
            percent = double_hetero / hetero

            output.append("\t".join([name, str(hetero), str(double_hetero), str(percent)]))

        with open(f"{output_path}/hetero_percent.tsv", "w") as fo:
            fo.write("\n".join(output))
    '''

end_time = time.time()

print(end_time - start_time)