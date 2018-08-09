#!/bin/bash

#script to use salmon to index assemblies for read mapping

### Environment ###
source /etc/profile.d/modules.sh
module load salmon

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
	for sample in  ${sample_list[@]}; do
		dir=02_Assemblies/${species}_${sample}_Trinity/
		forward=${dir}${sample}_R1.cor.fq.P.qtrim.gz
		reverse=${forward/R1./R2.}
		
		salmon quant -i ${dirout}${species}.index -l ISR \
			-1 ${forward} \
			-2 ${reverse} \
			--gcBias \
			-p 60 -o ${dirout}${species}_${sample}_quant
	done
done
