#!/bin/bash

### Environment ###
source /etc/profile.d/modules.sh

### Directories ###
WD=$PWD
mkdir -p 03_Merging

### Assemblers and other programs ###

### Species ###
species_list=( Pmono Plong Mensi Plati Psemi Mende Pescu Fmerg Lvana )

#Concatenating all output files from the different assemblers into one file
for species in ${species_list[@]}; do
	cat 03_Merging/${species}_*_all.fasta >  03_Merging/${species}_all.fasta &
done

