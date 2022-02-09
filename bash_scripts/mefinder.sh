#!/bin/bash

#SBATCH -A <allocation>
#SBATCH --job-name=mefinder-contigs

#SBATCH --mail-user=<email>
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 8:00:00 # Runtime in HH:MM:SS
#SBATCH -p <partition>

#SBATCH --mem=0
#SBATCH --output=./MGEs_metaspades/mefinder-contigs_%A_%a_out.txt
#SBATCH --error=./mefinder-contigs_%A_%a_err.txt
#SBATCH --array=0-9 # job array index

# purge all modules
module purge all

# load modules
module load python-anaconda3/2019.10
module load singularity

# get sample names
sample=($(cat SampleNames.txt))

# move to output folder
cd ./MGEs_metaspades

# run MobileElementFinder
singularity exec -B /path/to/image/ -B /path/to/data/ /path/to/image/Images/mobile_element_finder_latest.sif mefinder find --contig /path/to/data/metaspades_output/contigs_fasta/${sample[${SLURM_ARRAY_TASK_ID}]}_contigs.fasta -g -t 24 --temp-dir /path/to/data/MGEs_metaspades output_${sample[${SLURM_ARRAY_TASK_ID}]}_contigs
