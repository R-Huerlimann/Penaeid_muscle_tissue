#!/bin/bash

#script to use salmon to index assemblies for read mapping

### Environment ###
source /etc/profile.d/modules.sh
module load salmon

### Directories ###
dirin=04_Annotation/
dirout=05_Read_mapping/

### Species ###
species_list=( Pmono Plong Mensi Plati Psemi Mende Pescu Fmerg Lvana )

mkdir -p 05_Read_mapping

### Salmon indexing ###
for i in ${species_list[@]}; do
	echo "starting $i"
	salmon index -t ${dirin}${i}_final.fasta -i ${dirout}${i}.index
	echo "done"
done


