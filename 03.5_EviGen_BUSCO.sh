#!/bin/bash

### Environment ###
source /etc/profile.d/modules.sh
module load cd-hit
module load blast

### Directories ###
WD=$PWD

### Species ###
species_list=( Pmono Plong Mensi Plati Psemi Mende Pescu Fmerg Lvana )

#Running BUSCO on okay, okalt, and combined outputs
for species in ${species_list[@]}; do
	echo "Processing ${species}"
	cd ${WD}/03_Merging/${species}_merging/okayset
	cat  ${species}_all.rn.okay.rn.fasta ${species}_all.rn.okalt.rn.fasta > ${species}_all.EVGEall.fasta
	nohup BUSCO2_start.sh ${species}_all.rn.okay.rn.fasta 50 
	nohup BUSCO2_start.sh ${species}_all.rn.okalt.rn.fasta 50
	nohup BUSCO2_start.sh ${species}_all.EVGEall.fasta 50
done

