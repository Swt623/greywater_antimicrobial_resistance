#!/bin/bash

#SBATCH -A <allocation>
#SBATCH --job-name=nonpareil

#SBATCH --mail-user=<email>
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 06:00:00 # Runtime in D-HH:MM
#SBATCH -p <partition>

#SBATCH --mem=4G
#SBATCH --output=Nonpareil_%A_%a_out.txt
#SBATCH --error=Nonpareil_%A_%a_err.txt
#SBATCH --array=0-9 # job array index 

module purge all
module load python-anaconda3
source activate nonpareil

# get name list for job array
# go to directory for the samples
cd /path/to/qc_fasta_files/
sample1=($(cat sample1.txt))
sample=($(cat SampleNames.txt))

# nonpareil
nonpareil -s ${sample1[${SLURM_ARRAY_TASK_ID}]}.fasta -T alignment -f fasta -b ../nonpareil_out2/${sample[${SLURM_ARRAY_TASK_ID}]} -t 24
