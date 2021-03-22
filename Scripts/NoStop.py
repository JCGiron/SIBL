# Import modules
import sys
import os
from Bio.Seq import Seq
from Bio.Seq import UnknownSeq
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
from Bio.Alphabet import generic_alphabet

def NoStop(input_file_path,out_name):
	"""NoStop removes stop codons (that are hard coded in the function; change based on taxa/phyla). Function takes an input "file/path" and a "suffix" which is appended to the infile name."""
	codon_stop_array = ["TGA", "TAG", "TAA", "UGA", "UAA", "UAG"]
	#input_file_path = "/Users/chriswirth/Desktop/PruinescenceSeqs/CAD/CAD_Mod/CAD_AllData_mod.fasta"
	file_ext = os.path.basename(input_file_path)
	file, ext = os.path.splitext(file_ext)
	#NB/caution: Assumes sequences are in frame!
	for record in SeqIO.parse(input_file_path, "fasta", generic_alphabet):
		temp_seq = Seq("", generic_alphabet)
		for index in range(0,len(record.seq), 3):
			codon = record.seq[index:index+3]
			if codon in codon_stop_array:
				codon=UnknownSeq(3, character = '?')
			#Note += syntax here
			temp_seq+=codon
		#Write output to a .fasta file, note format
		fasta_format_string = (">%s\n%s" % (record.name, temp_seq))
		a=open("%s_%s.fasta" %(file,out_name), "a+")
		print >>a, fasta_format_string
		a.close()
		#Write change log to a .txt file; could record issues/changes across all "genes" if desired, but I've restricted to only a single AllData file for now
		b=open("%s_log.csv" %file, "a+")
		# Prints CSV with path and filename, taxon name, number of stop codons, and position (-1 if none, can be cleaned up easily) of first stop codon
		print >>b, file,",",record.name,",",temp_seq.count("???"),",",temp_seq.find("???")
		b.close()
	return
if __name__ == '__main__':
    NoStop(*sys.argv[1:])