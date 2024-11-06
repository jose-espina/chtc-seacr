#!/bin/bash
#
# seacr-callpeak.sh
# calling peaks using seacr
# Usage: seacr-callpeak.sh <samplename> <treatment> <control> <setting>

# mkdir
export HOME=$PWD
mkdir -p input

# clone SEACR git repo
git clone https://github.com/FredHutch/SEACR.git

# assign samplename to $1
# assign treatment to $2 and control to $3
# assign setting to $4
samplename=$1
treatment=$2
control=$3
setting=$4

# copy bedgraph files from staging to input
cp /staging/groups/roopra_group/jespina/$treatment input
cp /staging/groups/roopra_group/jespina/$control input

# print $treatment and $control to stdout
echo "Calling peaks from " $treatment
echo "Control: " $control

# run seacr script
bash SEACR/SEACR_1.3.sh input/$treatment input/$control norm $setting $samplename

# move output bed to staging
mv ${samplename}.${setting}.bed /staging/groups/roopra_group/jespina

# before script exits, remove files from working directory
rm -r input SEACR 

###END
