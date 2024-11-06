#!/bin/bash
#
# seacr-prep.sh
# generating bedgraph files from bam for seacr peak-calling
# Usage: seacr-prep.sh <bam>

# mkdir
export HOME=$PWD
mkdir -p input output

# assign bam to $1
bam=$1

# copy $bam and index from staging to input
cp /staging/groups/roopra_group/jespina/$bam input
cp /staging/groups/roopra_group/jespina/${bam}.bai input
cp /staging/groups/roopra_group/jespina/mm10.chrom.sizes.txt input

# get basename of $bam and assign to $samplename for naming output files
samplename=`basename $bam .bam`

# print name of $bam to stdout
echo "Converting" $bam "to bedgraph"

# convert to bedgraph
bedtools bamtobed -bedpe -i input/$bam > input/${samplename}.bed
awk '$1==$4 && $6-$2 < 1000 {print $0}' input/${samplename}.bed > input/${samplename}.clean.bed
cut -f 1,2,6 input/${samplename}.clean.bed | sort -k1,1 -k2,2n -k3,3n > input/${samplename}.fragments.bed
grep -i "^chr" input/${samplename}.fragments.bed > input/${samplename}_clean.fragments.bed
bedtools genomecov -bg -i ${samplename}_clean.fragments.bed -g input/mm10.chrom.sizes.txt > output/${samplename}_clean.fragments.bedgraph

# move bedgraph to staging
cd output
mv ${samplename}_clean.fragments.bedgraph /staging/groups/roopra_group/jespina
cd ~

# before script exits, remove files from working directory
rm -r input output

###END
