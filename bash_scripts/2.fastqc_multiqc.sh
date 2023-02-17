#!/bin/bash

#SBATCH -A <allocation>
#SBATCH --job-name=fastqc-multiqc

#SBATCH --mail-user=<email>
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=1 # Request that ncpus be allocated per process.

#SBATCH -t 6:00:00 # Runtime in D-HH:MM
#SBATCH -p <partition>

#SBATCH --mem=1G
#SBATCH --output=fastqc-multiqc_%A_out.txt
#SBATCH --error=fastqc-multiqc_%A_err.txt

# purge all modules
module purge all

# load needed modules
module load python-anaconda3/2019.10
module load fastqc/0.11.5

# activate environment
source activate multiqc

cd /path/to/files/

sample=($(cat sample_names.txt))
for i in {0..10}
do
	fastqc ./kneaddata_out/${sample[$i]}_*_paired_1.fastq.gz -o ./QC/fastqc_kneaddata/
	fastqc ./kneaddata_out/${sample[$i]}_*_paired_2.fastq.gz -o ./QC/fastqc_kneaddata/
done

# run multiqc
multiqc -o ./QC/multiqc_out ./QC/fastqc_kneaddata/