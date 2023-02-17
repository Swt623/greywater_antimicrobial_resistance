#!/bin/bash

#SBATCH -A <allocation>
#SBATCH --job-name=metaphlan2

#SBATCH --mail-user=<email>
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 4:00:00 # Runtime in HH:MM:SS
#SBATCH -p <partition>

#SBATCH --mem=12G
#SBATCH --output=metaphlan2_%A_%a_out.txt
#SBATCH --error=metaphlan2_%A_%a_err.txt

# purge all modules
module purge all

# load needed modules
module load singularity

# get name list for job array
cd /path/to/qc_fastq_files/
mate1=($(cat sample1.txt))
mate2=($(cat sample2.txt))
sample=($(cat SampleNames.txt))

# run Metaphlan2 in Singularity
singularity exec -B /path/to/data/ -B /path/to/image/ /path/to/image/biobakery_diamondv0822.sif metaphlan2.py ${mate1[$i]}.fastq,${mate2[$i]}.fastq --input_type fastq --bowtie2out ../metaphlan2_out/${sample[$i]}.bowtie2.bz2 --nproc 12 > ../metaphlan2_out/profiled_${sample[$i]}.txt


