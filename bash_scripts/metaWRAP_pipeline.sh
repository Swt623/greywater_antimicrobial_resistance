#!/bin/bash

#SBATCH -A <allocation>
#SBATCH --job-name=metaWARP

#SBATCH --mail-user=<email>
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 168:00:00 # Runtime in HH:MM:SS
#SBATCH -p <partition>

#SBATCH --mem=96G
#SBATCH --output=bin-reassemble_out_%A_%a.txt
#SBATCH --error=bin-reassemble_err_%A_%a.txt
#SBATCH --array=0-9 #job array index

# purge all modules
module purge all
# load module
module load python-anaconda3/2019.10
# activate metaWRAP environment
source activate metawrap-env
# add metaWRAP executables to PATH
export PATH=$PATH:/projects/p31421/software/metaWRAP/bin

cd /path/to/data/

# get sample name list
sample1=($(cat ./sample1.txt))
sample2=($(cat ./sample2.txt))
sample=($(cat ./SampleNames.txt))

# binning 
metaWRAP binning -o ./INITIAL_BINNING/ -t 24 -a ./path/to/scaffolds/final.contigs.fa --maxbin2 --concoct --metabat2 ./READS.fastq

# bin refinement with 80% completeness, 10% contamination
metaWRAP bin_refinement -o ./BIN_REFINEMENT/ -A ./INITIAL_BINNING/concoct_bins -B ./INITIAL_BINNING/maxbin2_bins -C ./INITIAL_BINNING/metabat2_bins -t 24 -m 128 -c 80 -x 10

# Find the abundaces of the draft genomes (bins) across the samples (for co-assembly)
metawrap quant_bins -b ./BIN_REFINEMENT/metawrap_80_10_bins -o ./QUANT_BINS -a ./coassembly/final.contigs.fa ./ALL_READs.fastq

# reassemble bins
metaWRAP reassemble_bins -o ./BIN_REASSEMBLY -b ./BIN_REFINEMENT/metawrap_80_10_bins -1 ./greywater_paired_1.fastq -2 ./greywater_paired_2.fastq -t 24 --parallel

# classify bins 
metaWRAP classify_bins -b ./reassembled_bins_90_5/${sample[${SLURM_ARRAY_TASK_ID}]}/reassembled_bins/ -o ./classify_80_10/${sample[${SLURM_ARRAY_TASK_ID}]} -t 24 

# other tools
# blobology
metaWRAP blobology -a ./${sample[${SLURM_ARRAY_TASK_ID}]}/final.contigs.fa -t 24 -o ./blobology/${sample[${SLURM_ARRAY_TASK_ID}]} --bins ./refined_bin/${sample[${SLURM_ARRAY_TASK_ID}]}/metawrap_80_10_bins ./${sample[${SLURM_ARRAY_TASK_ID}]}_*.fastq

