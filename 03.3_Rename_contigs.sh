#!/bin/bash

### Directories ###
WD=$PWD

### Species ###
species_list=( Pmono Plong Mensi Plati Psemi Mende Pescu Fmerg Lvana )

#Using rename_fasta.pl to rename the contigs in the different input files
for species in ${species_list[@]}; do
	echo "Processing ${species}"
	cd ${WD}/03_Merging/${species}_merging
	perl /bin/rename_fasta.pl -i ${species}_all.fasta -b contig &
done

