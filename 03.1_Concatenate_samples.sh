#!/bin/bash

### Environment ###
source /etc/profile.d/modules.sh

### Directories ###
WD=$PWD
mkdir -p 03_Merging

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


#Concatenating all output files from the different assemblers into one file
for species in ${species_list[@]}; do
	eval samples='$'{$species[@]}
	for sample in ${samples[@]}; do
		echo "Concatenating ${species} sample ${sample}"
		#Parameters
		outputTrinity=02_Assemblies/${species}"_"${sample}"_Trinity"
		outputShannon=${outputTrinity/Trinity/Shannon}
		outputBinPacker=${outputTrinity/Trinity/BinPacker}
		outputIDBAtran=${outputTrinity/Trinity/IDBAtran}
		outputOases=${outputTrinity/Trinity/Oases}
	
		cat ${outputTrinity}/Trinity.fasta \
			${outputShannon}/shannon.fasta \
			${outputBinPacker}/BinPacker.fa \
			${outputIDBAtran}/contig-[2-6]0.fa \
			${outputOases}/${species}"_"${sample}_*/transcripts.fa \
			| awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' | tail -n +2 > 03_Merging/${species}_${sample}_all.fasta &
		
	done
done

