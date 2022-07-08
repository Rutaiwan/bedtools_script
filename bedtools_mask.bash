#!/usr/bin/env bash

# USAGE: bash bedtools_mask.sh mask_list.bed reference.fasta /srv/rutaiwan/acinetobacter/bedtools

BEDS=$1	#bed file (include core-self mask, phast, gubbins)
REFERENCE=$2 #use reference fasta
MASKEDFASTA=$3 # eg. /srv/rutaiwan/acinetobacter/bedtools

#don't edit below this unless you know what you are doing

##Bedtools should be installed, if not then 
##conda install -c bioconda bedtools

#create output directory
mkdir ${MASKEDFASTA}/bedtools_output


#Bedtools to mask the postion of nucleotides in fasta file (reference) 
bedtools maskfasta -fi ${REFERENCE} -bed ${BEDS} -fo ${MASKEDFASTA}/bedtools_output/bedtools_output.fasta -mc N 
				    
				   
#Seqkit to count number of A,C,G,T
seqkit fx2tab -H -n -i -B A -B C -B G -B T -B N ${MASKEDFASTA}/bedtools_output/bedtools_output.fasta > ${MASKEDFASTA}/bedtools_output/seqkit_%recombination.tsv

#Count number of nucleotides (As, Cs, Gs, Ts, Ns)
grep -v "^>" ${MASKEDFASTA}/bedtools_output/bedtools_output.fasta | tr -cd N | wc -c > ${MASKEDFASTA}/bedN.tsv
grep -v "^>" ${MASKEDFASTA}/bedtools_output/bedtools_output.fasta | tr -cd A | wc -c > ${MASKEDFASTA}/bedA.tsv
grep -v "^>" ${MASKEDFASTA}/bedtools_output/bedtools_output.fasta | tr -cd C | wc -c > ${MASKEDFASTA}/bedC.tsv
grep -v "^>" ${MASKEDFASTA}/bedtools_output/bedtools_output.fasta | tr -cd G | wc -c > ${MASKEDFASTA}/bedG.tsv
grep -v "^>" ${MASKEDFASTA}/bedtools_output/bedtools_output.fasta | tr -cd T | wc -c > ${MASKEDFASTA}/bedT.tsv
grep "" ${MASKEDFASTA}/bed*.tsv > ${MASKEDFASTA}/bedtools_output/constantsites_output.tsv

#Remove unnescessary files
rm -r ${MASKEDFASTA}/bedN.tsv 
rm -r ${MASKEDFASTA}/bedA.tsv 
rm -r ${MASKEDFASTA}/bedC.tsv 
rm -r ${MASKEDFASTA}/bedG.tsv 
rm -r ${MASKEDFASTA}/bedT.tsv 


##End of script