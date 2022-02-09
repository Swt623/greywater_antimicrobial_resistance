#!/bin/bash

#SBATCH -A <allocation>
#SBATCH --job-name=kraken2

#SBATCH --mail-user=<email>
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=12 # Request that ncpus be allocated per process.

#SBATCH -t 00:30:00 # Runtime in HH:MM:SS
#SBATCH -p short

#SBATCH --mem=0
#SBATCH --output=kraken2_%A_out.txt
#SBATCH --error=kraken2_%A_err.txt

# purge all modules
module purge all

# load needed modules(kraken2 available at QUEST)
module load kraken/2

# if not available at QUEST, need to install kraken2 and then build database
source activate kraken2
kraken2-build --download-taxonomy --threads 24 --db kraken2_taxonomy_db --use-ftp

# get sample names
sample=($(cat ./SampleNames.txt))
cd ./metaspades_MGE_contigs

for i in {0..9}
do
	kraken2 ${sample[${i}]}_MGE_contigs.fasta --threads 12 --output ${sample[${i}]}_kraken2out.txt --use-names
done