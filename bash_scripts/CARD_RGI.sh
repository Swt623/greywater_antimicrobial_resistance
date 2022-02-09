#!/bin/bash

#SBATCH -A <allocation>
#SBATCH --job-name=rgi

#SBATCH --mail-user=<email>
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 24:00:00 # Runtime in HH:MM:SS
#SBATCH -p <partition>

#SBATCH --mem=0
#SBATCH --output=rgi_%A_%a.out
#SBATCH --error=rgi_%A_%a.err
#SBATCH --array=0-9 # job array index

# purge all modules
module purge all

# load needed modules
module load python-anaconda3/2019.10
source activate rgi
# RGI version 5.2.1

module load bwa/0.7.15
module load bowtie2/2.4.1
module load samtools/1.10.1
module load bamtools/2.4.1
module load bedtools/2.29.2

# load CARD database, database version 3.1.2
cd path/to/CARD_database/

rgi load --card_json card.json --local
rgi load -i card.json --card_annotation card_database_v3.1.2.fasta --local
rgi load --wildcard_annotation wildcard_database_v3.1.2.fasta --wildcard_index wildcard/index-for-model-sequences.txt --card_annotation card_database_v3.1.2.fasta --local

# get sample names
sample1=($(cat ./sample1.txt))
sample2=($(cat ./sample2.txt))
sample=($(cat ./SampleNames.txt))

# run RGI bwt mode (for metagenome short reads)
rgi bwt -1 ./${sample1[${SLURM_ARRAY_TASK_ID}]}.fastq.gz -2 ./${sample2[${SLURM_ARRAY_TASK_ID}]}.fastq.gz -a bwa -o ./RGI/${sample[${SLURM_ARRAY_TASK_ID}]} -n 24 --include_wildcard --local --clean

# run RGI heatmap
rgi heatmap --input ./RGI --output ./RGI_heatmap

# run RGI main program (for assembly)
rgi main --input_sequence ./metaspades_output/${sample[${SLURM_ARRAY_TASK_ID}]}/${sample[${SLURM_ARRAY_TASK_ID}]}_scaffolds.fasta --output_file ./rgi_main_output/metaspades/${sample[${SLURM_ARRAY_TASK_ID}]} --input_type contig --num_threads 24 --clean


