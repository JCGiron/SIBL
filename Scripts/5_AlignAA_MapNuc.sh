#!/bin/bash
#Run the stop codon replace command on all the files



LIST=$1
let Count=0
exec < "$LIST"
while read LINE
do
cd  $LINE
ALNOUTFILE="$(echo *_StopRem_AllData_AA.fasta|sed 's/.fasta/_aln.fasta/g')"
ALNOUTFILEONELN="$(echo $ALNOUTFILE|sed 's/.fasta/_1ln.fasta/g')"
NUCALN="$(echo *_StopRem_AllData_nuc.fasta|sed 's/.fasta/_aln.fasta/g')"
NUCALNONELN="$(echo $NUCALN|sed 's/.fasta/_1ln.fasta/g')"
echo $ALNOUTFILE
echo $ALNOUTFILEONELN
echo $NUCALN
echo $NUCALNONELN
mafft-linsi *_StopRem_AllData_AA.fasta>$ALNOUTFILE
fasta_formatter -i $ALNOUTFILE -o $ALNOUTFILEONELN -w 0
/Users/kojunkanda/Desktop/1_Sepidiini_Analyses/1_ScriptsFinalsForSepidiini/pal2nal.pl $ALNOUTFILEONELN *_StopRem_AllData_nuc.fasta -output fasta >$NUCALN
fasta_formatter -i $NUCALN -o $NUCALNONELN -w 0

mv *_AA_aln.fasta MiscFiles
mv *_AA.fasta MiscFiles
mv *_nuc_aln.fasta MiscFiles
mv *_nuc.fasta MiscFiles


cd ..

done
