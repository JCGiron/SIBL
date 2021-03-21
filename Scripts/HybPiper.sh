#!/bin/sh -l 

#SBATCH -A smit3866
#SBATCH --time=10:00:00
#SBATCH --mem=100gb


module load bioinfo
module load biopython
module load exonerate 
module load blast
module load spades
module load parallel
module load bwa 
module load samtools

while read name; 
do /depot/smit3866/apps/HybPiper/reads_first.py -b PimTargets_SimpleNames.fasta -r $name*.fastq --prefix $name --bwa
done < namelist2021.txt

#Get Sequence Lengths (Quality Assessment)
python /depot/smit3866/apps/HybPiper/get_seq_lengths.py PimTargets_SimpleNames.fasta namelist2021.txt dna > test_2021_seq_lengths.txt

#Stats
python /depot/smit3866/apps/HybPiper/hybpiper_stats.py test_2021_seq_lengths.txt namelist2021.txt > test_2021_stats.txt

#Retrieve Sequences
python /depot/smit3866/apps/HybPiper/retrieve_sequences.py PimTargets_SimpleNames.fasta . dna


# Paralogs
while read i
do
echo $i
python /depot/smit3866/apps/HybPiper/paralog_investigator.py $i
done < namelist2021.txt

# Introns
while read name;
do python /depot/smit3866/apps/HybPiper/intronerate.py --prefix $name/ORTHO*
done <namelist2021.txt

# Clean up
while read name;
do python /depot/smit3866/apps/HybPiper/cleanup.py $name
done <namelist2021.txt
