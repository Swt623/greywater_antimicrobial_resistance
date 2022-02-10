#!/bin/bash

#SBATCH -A <allocation>
#SBATCH --job-name=metaspades

#SBATCH --mail-user=<email>
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 48:00:00 # Runtime in HH:MM:SS
#SBATCH -p genomics

#SBATCH --mem=0 # take the whole node
#SBATCH --output=metaspades_%A_%a_out.txt
#SBATCH --error=metaspades_%A_%a_err.txt
#SBATCH --array=0-9 # job array index

# purge all modules
module purge all

module load python-anaconda3/2019.10

# add spades to path
export PATH=$PATH:/projects/p31421/software/SPAdes-3.15.3-Linux/bin/

cd /path/to/data/
# get sample names
sample1=($(cat sample1.txt))
sample2=($(cat sample2.txt))
sample=($(cat SampleNames.txt))

# run spades in meta mode
spades.py --meta -1 ./kneaddata_out_decontaminate/${sample1[${SLURM_ARRAY_TASK_ID}]}.fastq.gz -2 ./kneaddata_out_decontaminate/${sample2[${SLURM_ARRAY_TASK_ID}]}.fastq.gz -o ./metaspades_output/${sample[${SLURM_ARRAY_TASK_ID}]} -t 24 

# if failed, can run with --continue flag
spades.py -o ./metaspades_output/${sample[${SLURM_ARRAY_TASK_ID}]} --continue

# for coassembly, spades runs into memory issues
spades.py --meta -1 greywater_paired_1.fastq.gz -2 greywater_paired_2.fastq.gz -o ./coassembly -t 8 -m 192
