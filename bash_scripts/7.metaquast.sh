#!/bin/bash

#SBATCH -A <allocation>
#SBATCH --job-name=metaquast

#SBATCH --mail-user=<email>
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 
#SBATCH -t 12:00:00 # Runtime in HH:MM:SS
#SBATCH -p <partition>

#SBATCH --mem=0
#SBATCH --output=metaquast_%A_out.txt
#SBATCH --error=metaquast_%A_err.txt

# purge all modules
module purge all
module load python-anaconda3/2019.10
module load blast/2.7.1
export PATH=$PATH:/software/blast/ncbi-blast-2.7.1+/bin

# get sample names
sample=($(cat SampleNames.txt))

# run quast
cd /path/to/contigs/

python /projects/p31421/software/quast-5.0.2/metaquast.py -o ./quast_results_10_21_2021/ -t 24 -L ./${sample[0]}/final.contigs.fa ./${sample[1]}/final.contigs.fa ./${sample[2]}/final.contigs.fa ./${sample[3]}/final.contigs.fa ./${sample[4]}/final.contigs.fa ./${sample[5]}/final.contigs.fa ./${sample[6]}/final.contigs.fa ./${sample[7]}/final.contigs.fa ./${sample[8]}/final.contigs.fa ./${sample[9]}/final.contigs.fa

# "--gene-finding" flag enables gene finding. for metaquast, MetaGeneMark is used. 

