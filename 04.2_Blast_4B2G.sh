#!/bin/bash

### Environment ###
source /etc/profile.d/modules.sh
module load blast

### how to run ###
#nohup 04.2_Blast.sh $> 04.2_Blast.log 

### Directories ###
WD=$PWD

### Species ###
species_list=( Pmono Plong Mensi Plati Psemi Mende Pescu Fmerg Lvana )

### Running Blast ###

for i in ${species_list[@]}; do
	echo "starting $i"
	dir=04_Annotation/
	blastx -db /Databases/NCBI/nr_art_vir -query ${dir}${i}_final.fasta -out ${dir}${i}_final_blast_4B2G.xml -show_gis -num_threads 60 -evalue 1e-5 -word_size 3 -num_alignments 20 -outfmt 5 -max_hsps 20
	echo "done"
done
