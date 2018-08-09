#!/bin/bash

#renaming the {species}_final.fasta files

### Species ###
species_list=( Pmono Plong Mensi Plati Psemi Mende Pescu Fmerg Lvana )

### Adding species IDs to contig IDs ###
for i in ${species_list[@]}; do
       echo "renaming $i"
       sed -i.bak "s|contig|${i}_contig|" 04_Annotation/${i}_final_raw.fasta
       echo "done"
done
