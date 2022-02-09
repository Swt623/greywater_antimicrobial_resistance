#!/bin/bash

#SBATCH -A <allocation>
#SBATCH --job-name=bowtie2-samtools

#SBATCH --mail-user=<email address>
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 60:00:00 # Runtime in HH:MM:SS
#SBATCH -p <partition>

#SBATCH --mem=48G
#SBATCH --output=bowtie2-samtools_%A_out.txt
#SBATCH --error=bowtie2-samtools_%A_err.txt

module purge all
module load bowtie2
module load samtools

# Sample name list.
sample=($(cat SampleNames.txt))

# Use refined bins for bin abundance
cd /BIN_REFINEMENT_megahit/metawrap_80_10_bins/

# Loop over bins to create bowtie2 index files.
mkdir ./map_bt2/
for F in *.fa
do
	N=$(basename $F .fa)
	bowtie2-build $F ./map_bt2/$N
done
echo "Complete bowtie2 indexing."

# Loop over 10 samples to get sam files. 
mkdir ./bt2_out/
for i in {0..9}
do
	mkdir ./bt2_out/${sample[${i}]}/
	for F in *.fa
	do
		N=$(basename $F .fa)
		bowtie2 --threads 24 -x /map_bt2/$N \
		-1 ./${sample[${i}]}_*_kneaddata_paired_1.fastq \
		-2 ./${sample[${i}]}_*_kneaddata_paired_2.fastq \
		-S ./bt2_out/${sample[${i}]}/$N.sam \
		--no-unal
	done
	echo "Complete bowtie2 mapping for ${sample[${i}]}."
	
# Sort sam files to get sorted bam files.
	echo "Start samtools with ${sample[$i]}."
	mkdir ./bt2_out/sorted_bam/${sample[$i]}/
	cd ./bt2_out/${sample[$i]}/
	for Fs in *.sam
	do
		B=$(basename $Fs .sam)
		samtools view -@ 12 -bS ./bt2_out/${sample[$i]}/$Fs | samtools sort -@ 12 -o ./bt2_out/sorted_bam/${sample[$i]}/$B\_sorted.bam
		cd ./bt2_out/sorted_bam/${sample[$i]}/
		samtools index $B\_sorted.bam
	done

# Calculate bin depth in each sample.
	cd ./bt2_out/sorted_bam/${sample[$i]}/
	for M in *_sorted.bam
	do
		BinName=$(basename $M _sorted.bam)
		echo $BinName >> ${sample[$i]}_bin_list.txt
		samtools depth $M |  awk '{sum+=$3} END { print sum/NR,sqrt(sumsq/NR - (sum/NR)**2)}' >> ${sample[$i]}_bin_average_depth.txt
		samtools depth $M -a |  awk '{sum+=$3} END { print sum/NR,sqrt(sumsq/NR - (sum/NR)**2)}' >> ${sample[$i]}_bin_average_depth_all_base.txt
	done

# Create a list of bam file names
	cd /bt2_out/sorted_bam/${sample[$i]}/
	ls *_sorted.bam > ${sample[$i]}_bam_list.txt

# Paste results in txt file.
	cd ./bt2_out/sorted_bam/
	paste ./${sample[$i]}/${sample[$i]}_bin_list.txt ./${sample[$i]}/${sample[$i]}_bin_average_depth.txt ./${sample[$i]}/${sample[$i]}_bin_average_depth_all_base.txt > ./${sample[$i]}_bin_average_depth_summary.txt
	echo "Done with ${sample[$i]} samtools."
done

