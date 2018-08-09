#!/bin/bash

### Environment ###
source /etc/profile.d/modules.sh
module load cd-hit
module load blast

### Directories ###
WD=$PWD
transfuse=/Software/transfuse-0.5.0-linux-x86_64/transfuse

### Species ###
species_list=( Plong Mensi Plati Psemi Mende Pescu Fmerg Lvana )
#Pmono

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


#Running transfuse on okay and combined sets
for species in ${species_list[@]}; do
	eval samples="(" '$'{$species[@]} ")"
	echo "Processing ${species}"
	cd ${WD}/03_Merging/${species}_merging/okayset

	left1=$WD/02_Assemblies/${species}_${samples[0]}_Trinity/insilico_read_normalization/left.norm.fq
	right1=$WD/02_Assemblies/${species}_${samples[0]}_Trinity/insilico_read_normalization/right.norm.fq
	left2=$WD/02_Assemblies/${species}_${samples[1]}_Trinity/insilico_read_normalization/left.norm.fq
	right2=$WD/02_Assemblies/${species}_${samples[1]}_Trinity/insilico_read_normalization/right.norm.fq
	left3=$WD/02_Assemblies/${species}_${samples[2]}_Trinity/insilico_read_normalization/left.norm.fq
	right3=$WD/02_Assemblies/${species}_${samples[2]}_Trinity/insilico_read_normalization/right.norm.fq
	
	$transfuse --assemblies=${species}_all.rn.okay.rn.fasta \
		--left=${left1},${left2},${left3} \
		--right=${right1},${right2},${right3} \
		--output=Transfuse_${species}_all.rn.okay \
		--threads=50 --id=1.0 --verbose

done

	


