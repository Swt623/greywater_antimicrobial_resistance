#!/bin/bash

#SBATCH -A <allocation>
#SBATCH --job-name=QC

#SBATCH --mail-user=<email>
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=1 # Request that ncpus be allocated per process.

#SBATCH -t 24:00:00 # Runtime in D-HH:MM
#SBATCH -p <partition>

#SBATCH --mem=24G
#SBATCH --output=qc_%A_out.txt
#SBATCH --error=qc_%A_err.txt

# purge all modules
module purge all

# load needed modules
module load fastqc/0.11.5

# get name list for raw data
cd ./greywater/sequence
raw1=($(cat sample_names1.txt))
raw2=($(cat sample_names2.txt))

cd ./greywater/kneaddata_out
qc1=($(cat kneaddata_out_names1.txt))
qc2=($(cat kneaddata_out_names2.txt))

# loop over name list
cd ./greywater/
for i in {0..11}
do
# run 
  fastqc sequence/${raw1[$i]} -o fastqc_raw/
  fastqc sequence/${raw2[$i]} -o fastqc_raw/
  fastqc kneaddata_out/${qc1[$i]}.fastq -o fastqc_qc/
  fastqc kneaddata_out/${qc2[$i]}.fastq -o fastqc_qc/
done

