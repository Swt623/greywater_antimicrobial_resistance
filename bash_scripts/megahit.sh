#!/bin/bash

#SBATCH -A <allocation>
#SBATCH --job-name=megahit

#SBATCH --mail-user=<email>
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 12:00:00 # Runtime in HH:MM:SS
#SBATCH -p genomics

#SBATCH --mem=0
#SBATCH --output=megahit_%A_%a_out.txt
#SBATCH --error=megahit_%A_%a_err.txt
#SBATCH --array=0-9 # job array index

# purge all modules
module purge all
module load python-anaconda3/2019.10
source activate megahit
megahit -v # MEGAHIT v1.2.9

# get sample names
sample1=($(cat sample1.txt))
sample2=($(cat sample2.txt))
sample=($(cat SampleNames.txt))

# run megahit
megahit -1 ./kneaddata_out_decontaminate/${sample1[${SLURM_ARRAY_TASK_ID}]}.fastq.gz -2 ./kneaddata_out_decontaminate/${sample2[${SLURM_ARRAY_TASK_ID}]}.fastq.gz -o ./megahit_output/${sample[${SLURM_ARRAY_TASK_ID}]} -t 24 

# for co-assembly
megahit -1 greywater_paired_1.fastq.gz -2 greywater_paired_2.fastq.gz -o /projects/b1042/HartmannLab/weitao/coassembly-megahit/ -t 24 
