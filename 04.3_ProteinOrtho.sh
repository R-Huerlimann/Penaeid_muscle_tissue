#!/bin/bash

### Environment ###
source /etc/profile.d/modules.sh
module load blast

### Directories ###
WD=$PWD
proteinortho=/Software/proteinortho_v5.16b/proteinortho5.pl

### Species ###
species_list=( Pmono Plong Mensi Plati Psemi Mende Pescu Fmerg Lvana )

#creating a new folder and copying the final assemblies

cd 04_Annotation

mkdir -p ortho_temp_n
#Running proteinortho on all nine assemblies using nt
${proteinortho} -p=blastn+ -project=ortho_nt -cpus=60 -verbose -keep -temp=ortho_temp_n *.fasta

mkdir -p ortho_temp_tx
#Running proteinortho on all nine assemblies using aa
${proteinortho} -p=tblastx+ -project=ortho_tx -cpus=60 -verbose -keep -temp=ortho_temp_tx *.fasta







	


