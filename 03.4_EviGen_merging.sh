#!/bin/bash

### Environment ###
source /etc/profile.d/modules.sh
module load cd-hit
module load blast

### Directories ###
WD=$PWD

### Species ###
species_list=( Pmono Plong Mensi Plati Psemi Mende Pescu Fmerg Lvana )

#Using EviGen to merge redundant contigs in all assemblies
for species in ${species_list[@]}; do
	echo "Processing ${species}"
	cd ${WD}/03_Merging/${species}_merging
	nohup perl /Software/evigene/scripts/prot/tr2aacds.pl -mrnaseq ${species}_all.rn.fasta -NCPU=50 -MAXMEM=800000 -logfile
done

