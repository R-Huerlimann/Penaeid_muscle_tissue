#!/bin/bash

### Environment ###
source /etc/profile.d/modules.sh
module load cd-hit
module load blast

### Directories ###
WD=$PWD
transrate1=/Software/transrate-1.0.1-linux-x86_64/transrate #transrate 1.0.1 works a lot better with larger data sets than 1.0.3

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


#Running BUSCO and transfuse on TransFuse processed sets
for species in ${species_list[@]}; do
	eval samples="(" '$'{$species[@]} ")"
	echo "Processing ${species}"
	cd ${WD}/03_Merging/${species}_merging/okayset

	cp Transfuse_${species}_all.rn.okay ${species}_final.fasta
	
#BUSCO	
	nohup BUSCO2_start.sh ${species}_final.fasta 50 

#TransRate
	left1=$WD/02_Assemblies/${species}_${samples[0]}_Trinity/insilico_read_normalization/left.norm.fq
	right1=$WD/02_Assemblies/${species}_${samples[0]}_Trinity/insilico_read_normalization/right.norm.fq
	left2=$WD/02_Assemblies/${species}_${samples[1]}_Trinity/insilico_read_normalization/left.norm.fq
	right2=$WD/02_Assemblies/${species}_${samples[1]}_Trinity/insilico_read_normalization/right.norm.fq
	left3=$WD/02_Assemblies/${species}_${samples[2]}_Trinity/insilico_read_normalization/left.norm.fq
	right3=$WD/02_Assemblies/${species}_${samples[2]}_Trinity/insilico_read_normalization/right.norm.fq
	
	${transrate1} --assembly=${species}_final.fasta \
		--left=${left1},${left2},${left3} \
		--right=${right1},${right2},${right3} \
		--threads=50 --output=${species}_final
		
done



	


