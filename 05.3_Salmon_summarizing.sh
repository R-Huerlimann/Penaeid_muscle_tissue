#!/bin/bash

#Script to rename and collate the result files from Salmon and turning it into a tab delimited file

### Directories ###
dirout=05_Read_mapping/

### Species ###
species_list=( Pmono Plong Mensi Plati Psemi Mende Pescu Fmerg Lvana )

### Samples ###
Pmono=( R23 R27 R59 )
Plong=( R83 R84 R85 )
Mensi=( R86 R87 R88 )
Plati=( R89 R90 R91 )
Psemi=( R92 R93 R94 )
Mende=( R95 R96 R97 )
Pescu=( R98 R99 R100 )
Fmerg=( R101 R102 R103 )
Lvana=( R104 R105 R106 )

### Salmon Quantification  ###
for species in ${species_list[@]}; do
	eval sample_list='$'{$species[@]}
	for sample in ${sample_list[@]}; do
		#copying and renaming files, as well as turning spaces into tabs
		cat ${dirout}${species}_${sample}_quant/quant.sf | sed 's| |\t|g' > ${dirout}${species}_${sample}_quant.sf
	done
	
	#joining the three files per species into one
	read -a list <<< $sample_list
	file1=${dirout}${species}_${list[0]}_quant.sf
	file2=${dirout}${species}_${list[1]}_quant.sf
	file3=${dirout}${species}_${list[2]}_quant.sf
		
	join -j 1 ${file1} ${file2} > ${dirout}file.temp
	join -j 1 ${dirout}file.temp ${file3} | sed 's| |\t|g' > ${dirout}${species}_all_quant.sf
	
	rm ${dirout}file.temp
	
done



