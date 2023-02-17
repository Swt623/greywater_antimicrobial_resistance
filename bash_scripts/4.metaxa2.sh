#!/bin/bash

#SBATCH -A <allocation>
#SBATCH --job-name=metaxa2

#SBATCH --mail-user=<email>
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 04:00:00 # Runtime in D-HH:MM
#SBATCH -p <partition>

#SBATCH --mem=0
#SBATCH --output=metaxa2_%A_%a_out.txt
#SBATCH --error=metaxa2_%A_%a_err.txt
#SBATCH --array=0-9 # job array index 

# purge all modules
module purge all

# load needed modules
module load metaxa2/2.2
module load blast/2.7.1

# get name list for job array
sample1=($(cat sample1.txt))
sample2=($(cat sample2.txt))
sample=($(cat SampleNames.txt))

cd /path/to/qc_fasta/files/

# run metaxa2
metaxa2 -1 ${sample1[${SLURM_ARRAY_TASK_ID}]}.fasta -2 ${sample2[${SLURM_ARRAY_TASK_ID}]}.fasta -o ../metaxa2_out/${sample[${SLURM_ARRAY_TASK_ID}]} --cpu 24 --align none --plus T

# metaxa2_ttt
metaxa2_ttt -i ./metaxa2_out/${sample[${SLURM_ARRAY_TASK_ID}]}.taxonomy.txt -o ./metaxa2_ttt/${sample[${SLURM_ARRAY_TASK_ID}]}

# metaxa2_dc
# loop over levels 1-9
for i in {1..9}
do
	metaxa2_dc -o ./metaxa2_dc/taxomony_all_level_${i}.txt /metaxa2_ttt/*level_${i}.txt
	echo "Collected metaxa2 output for level ${i}."
done

# other metaxa2 tools
# metaxa2_rf
metaxa2_rf -i ${sample[${SLURM_ARRAY_TASK_ID}]}.taxonomy.txt -o ../metaxa2_rf_decontaminate/${sample[${SLURM_ARRAY_TASK_ID}]} --separate F
