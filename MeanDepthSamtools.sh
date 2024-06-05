#!/bin/bash
#SBATCH --job-name=CalcMeanDepth # Job name
#SBATCH -p long
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --mem=16G                     # Job memory request
#SBATCH --cpus-per-task=8
#SBATCH --output=%x_%j_nobed.log   # Standard output and error l
#SBATCH --error=%x_%j_nobed.err

# Here we are going to calculate the average of depth per chromosome using bed file as guide
# As argument we have to use the name of the folder of the results of the sarek
# The second argument is the bed file
# The script have to be run in the same folder where your results are
echo "Working with files in" $1
for FILE in $(ls $1/preprocessing/recalibrated) # Here we iterate through all the files
do
	singularity run -H $PWD:/home/ samtools.sif samtools depth $1/preprocessing/recalibrated/$FILE/$FILE".recal.cram" -b $2 > $1/preprocessing/recalibrated/$FILE/$FILE"_depth.txt" # Be sure to have a image of samtools, if the name change you have to change the code
	rm $1/preprocessing/recalibrated/$FILE/$FILE"_meandepth.txt" # we are removing any previous files you have to overwrite  in case you did it wrong
	rm $1/preprocessing/recalibrated/$FILE/$FILE"_depth.txt"
	for FILE1 in {1..22}; # We iterate through chromosomes
	do
		cat $1/preprocessing/recalibrated/$FILE/$FILE"_depth.txt" | grep -w "chr$FILE1" | awk -v file=$FILE '{depth+=$3;count++} END {if(count>0){average=depth/count;print file, "chr'$FILE1'", average}}' >> meandepth.txt" # The file is stored where you run the script and everything is appended there
	done
	cat $1/preprocessing/recalibrated/$FILE/$FILE"_depth.txt" | grep -w chrX | awk -v file=$FILE '{depth+=$3;count++} END {if(count>0){average=depth/count;print file, "chrX", average}}' >> meandepth.txt
	cat $1/preprocessing/recalibrated/$FILE/$FILE"_depth.txt" | grep -w chrY | awk -v file=$FILE '{depth+=$3;count++} END {if(count>0){average=depth/count;print file, "chrY", average}}' >> meandepth.txt
done
