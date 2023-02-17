#!/bin/bash

#SBATCH -A <allocation>
#SBATCH --job-name=Kneaddata

#SBATCH --mail-user=<email>
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 01:00:00 # Runtime in D-HH:MM
#SBATCH -p <partition>

#SBATCH --mem=8G
#SBATCH --output=Kneaddata_%A_%a_out.txt
#SBATCH --error=Kneaddata_%A_%a_err.txt
#SBATCH --array=0-9 # job array index 

# purge all modules
module purge all

# load needed modules
module load singularity

# get name list for job array
cd /path/to/raw_sequence/
sample1=($(cat sample_names1.txt))
sample2=($(cat sample_names2.txt))
sample=($(cat SampleNames.txt))

# run Kneaddata in Singularity
singularity exec -B /path/to/data/ -B /path/to/images/ -B /path/to/reference-db/ /path/to/images/biobakery_diamondv0822.sif kneaddata --input ${sample1[${SLURM_ARRAY_TASK_ID}]}.fastq.gz --input ${sample2[${SLURM_ARRAY_TASK_ID}]}.fastq.gz --reference-db /path/to/reference-db/kit_control/greywater_kc_db --reference-db /path/to/reference-db/Database/hg37dec_v0.1 --output /path/to/output/kneaddata_out --threads 24
# for --reference-db flag, need <path>/prefix-of-db-files

# delete outputs not needed
cd /path/to/output/kneaddata_out/
rm decompressed*_${sample[${SLURM_ARRAY_TASK_ID}]}_*.fastq
rm ${sample[${SLURM_ARRAY_TASK_ID}]}_R1*trimmed*.fastq
rm ${sample[${SLURM_ARRAY_TASK_ID}]}_R1*contam*.fastq

# zip output files to save space
gzip ${sample[${SLURM_ARRAY_TASK_ID}]}_R1_kneaddata_paired_*.fastq
gzip ${sample[${SLURM_ARRAY_TASK_ID}]}_R1_kneaddata_unmatched_*.fastq
