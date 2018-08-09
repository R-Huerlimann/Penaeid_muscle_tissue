#!/bin/bash

#Best run like this: nohup ./02_Analysis_start.sh [species abbreviation] &> species_date.log &
#e.g. nohup ./02_Analysis_start.sh Pmono &> Pmono_20180530.log &

### Environment ###
source /etc/profile.d/modules.sh
module load jellyfish #for trinity
module load samtools #for trinity
module load salmon #for trinity 2.6.6
module load python/2.7.13 #for shannon
module load shannon #for shannon 0.0.1
module load hmmer #for BUSCO 2
module load blast #for BUSCO 2
module load python/3.5.1 #for BUSCO 2
module load bamtools #to determine insert size for oases

### Directories ###
DIR=01_Data/3_Corrected/
WD=$PWD
mkdir -p 02_Assemblies

### Assemblers and other programs ###
Trinity=/Software/Trinityrnaseq-v2.6.6/Trinity
#Trinity=/Software/trinityrnaseq-2.4.0/Trinity
Shannon=/sw/shannon/shannon.py
#v0.0.1
BinPacker=/Software/BinPacker_binary/BinPacker
#v1.0
IDBAtran=/Software/idba-master/bin/idba_tran
#v1.1.1
oases=/Software/oases/scripts/oases_pipeline.py
#v0.2.04

fq2fa=/Software/idba-master/bin/fq2fa
transrate1=/Software/transrate-1.0.1-linux-x86_64/transrate #transrate 1.0.1 works a lot better with larger data sets than 1.0.3
busco=/Software/busco/BUSCO.py #this is BUSCO version 2. It was not possible to install version 3 at this point.

odb9=/Databases/BUSCO_db/arthropoda_odb9

### Species ###
species_list=( Pmono Plong Mensi Plati Psemi Mende Pescu Fmerg Lvana ) #not used, but here for reference
species=$1

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
eval samples='$'{$1[@]}

#Runing all three replicates of a sample through four assemblers
echo
echo "=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*="
echo "Starting assembly of ${species} consisting of samples ${samples}"
echo "=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*="


for sample in ${samples[@]}; do
	#Parameters
	forward=${DIR}${sample}"_R1.cor.fq"
	reverse=${forward/_R1/_R2}
	outputTrinity=02_Assemblies/${species}"_"${sample}"_Trinity"
	outputShannon=${outputTrinity/Trinity/Shannon}
	outputBinPacker=${outputTrinity/Trinity/BinPacker}
	outputIDBAtran=${outputTrinity/Trinity/IDBAtran}
	outputOases=${outputTrinity/Trinity/Oases}
	bampath=${outputTrinity}/transrate_1.0.1_${sample}_trinity/Trinity
	left=${outputTrinity}/insilico_read_normalization/left.norm.fq
	right=${outputTrinity}/insilico_read_normalization/right.norm.fq
	
#Trinity
	echo "__________________________________________________________"
	if [ ! -f ${outputTrinity}/Trinity.fasta ]; then
		echo "Starting assembly of ${species} ${sample} in Trinity on `date`"
		${Trinity} --seqType fq --max_memory 200G --trimmomatic \
			--left $forward --right $reverse --SS_lib_type RF --CPU 15 \
			--output ${outputTrinity} \
			--quality_trimming_params "ILLUMINACLIP:/2_Transcriptome/5_muscle_transcriptomes/01_Data/4_illumina_adaptors_all_curated.fasta:2:40:15 LEADING:2 TRAILING:2 MINLEN:25" &> 02_Assemblies/${species}"_"${sample}"_trinity.log" 
		echo "Finished on `date`"
	else
		echo "Trinity assembly already done for ${species} ${sample}"
	fi
	echo
	
	#Transrate
	if [ ! -d ${outputTrinity}/transrate_1.0.1_${sample}_trinity ]; then
		echo "Running TransRate on ${species} ${sample} on `date`"
		${transrate1} --assembly=${outputTrinity}/Trinity.fasta \
			--left=${outputTrinity}/insilico_read_normalization/left.norm.fq \
			--right=${outputTrinity}/insilico_read_normalization/right.norm.fq \
			--threads=15 --output=${outputTrinity}/transrate_1.0.1_${sample}_trinity
	else
		echo "TransRate already run"
	fi
	echo

	#BUSCO
	if [ ! -d ${outputTrinity}/run_BUSCO* ]; then
		echo "Running BUSCO on ${sample} on `date`"
		cd ${outputTrinity}
		python3 $busco -o BUSCO2_${sample} -i Trinity.fasta -l $odb9 -m tran -c 15
		cd $WD
	else
		echo "BUSCO already run"
	fi
	echo
	
	echo "Finished processing ${sample} in Trinity on `date`"
	echo
	
#Shannon
	echo "__________________________________________________________"
	if [ ! -f ${outputShannon}/shannon.fasta ]; then
		echo "Starting assembly of ${species} ${sample} in Shannon on `date`"
		nohup python ${Shannon} -p 15 -o ${outputShannon} \
			--left ${outputTrinity}/${sample}"_R2.cor.fq.PwU.qtrim.fq" \
			--right ${outputTrinity}/${sample}"_R1.cor.fq.PwU.qtrim.fq" \
			--ss &> 02_Assemblies/${species}"_"${sample}"_shannon.log" 
		echo "Finished on `date`"
	else
		echo "Shannon assembly already done for ${species} ${sample}"
	fi
	echo
	
	#Transrate	
	if [ ! -d ${outputShannon}/transrate_1.0.1_${sample}_shannon ]; then
		echo "Running TransRate on ${species} ${sample} on `date`"
		${transrate1} --assembly=${outputShannon}/shannon.fasta \
			--left=${outputTrinity}/${sample}"_R1.cor.fq.PwU.qtrim.fq" \
			--right=${outputTrinity}/${sample}"_R2.cor.fq.PwU.qtrim.fq" \
			--threads=15 --output=${outputShannon}/transrate_1.0.1_${sample}_shannon
	else
		echo "TransRate already run"
	fi
	echo
		
	#BUSCO
	if [ ! -d ${outputShannon}/run_BUSCO* ]; then
		echo "Running BUSCO on ${species} ${sample} on `date`"
		cd ${outputShannon}
		python3 $busco -o BUSCO2_${sample} -i shannon.fasta -l $odb9 -m tran -c 15
		cd $WD
	else
		echo "BUSCO already run"
	fi
	echo
	
	echo "Finished ${species} ${sample} in Shannon on `date`"
	echo
	
#BinPacker
	echo "__________________________________________________________"
	if [ ! -f ${outputBinPacker}/BinPacker.fa ]; then
		echo "Starting assembly of ${species} ${sample} in BinPacker on `date`"
		mkdir -p ${outputBinPacker}
		cd ${outputBinPacker}
		${BinPacker} -s fq -p pair \
			-l ${WD}/${left} \
			-r ${WD}/${right} \
			-m RF -q -o $WD/${outputBinPacker} &> $WD/02_Assemblies/${species}"_"${sample}"_binpacker.log" 
		mv BinPacker_Out_Dir/* .
		rm -r BinPacker_Out_Dir/
		cd $WD
		echo "Finished on `date`"
	else
		echo "BinPacker assembly already done for ${species} ${sample}"
	fi
	echo
	
	#Transrate
	if [ ! -d ${outputBinPacker}/transrate_1.0.1_${sample}_BinPacker ]; then
		echo "Running TransRate on ${species} ${sample} on `date`"
		${transrate1} --assembly=${outputBinPacker}/BinPacker.fa \
			--left=${left} \
			--right=${right} \
			--threads=15 --output=${outputBinPacker}/transrate_1.0.1_${sample}_BinPacker

	else
		echo "TransRate already run"
	fi
	echo
		
	#BUSCO
	if [ ! -d ${outputBinPacker}/run_BUSCO* ]; then
		echo "Running BUSCO on ${species} ${sample} on `date`"
		cd ${outputBinPacker}
		python3 $busco -o BUSCO2_${sample} -i BinPacker.fa -l $odb9 -m tran -c 15
		cd $WD
	else
		echo "BUSCO already run"
	fi
	echo
	
	echo "Finished ${species} ${sample} in BinPacker on `date`"
	echo

#IDBA-tran
	echo "__________________________________________________________"
	mkdir -p ${outputIDBAtran}
	if [ ! -f ${outputIDBAtran}/merged_for_idba.fa ]; then
		echo "Preparing data for idba-tran (fq to fa conversion)"
		${fq2fa} --merge ${left} ${right} ${outputIDBAtran}/merged_for_idba.fa
		echo "Finished!"
		echo
	fi
	
	if [ ! -f ${outputIDBAtran}/contig.fa ]; then
		echo "Starting assembly of ${species} ${sample} in IDBA-tran on `date`"
		${IDBAtran} --read ${outputIDBAtran}/merged_for_idba.fa --out ${outputIDBAtran} --num_threads 15 &> 02_Assemblies/${species}"_"${sample}"_idbatran.log"	
		echo "Finished on `date`"
	else
		echo "IDBA-tran assembly already done for ${species} ${sample}"
	fi
	echo
		
	#Transrate
	if [ ! -d ${outputIDBAtran}/transrate_1.0.1_${sample}_IDBAtran ]; then
		echo "Running TransRate on ${species} ${sample} on `date`"
		${transrate1} --assembly=${outputIDBAtran}/contig.fa \
			--left=${left} \
			--right=${right} \
			--threads=15 --output=${outputIDBAtran}/transrate_1.0.1_${sample}_IDBAtran
	else
		echo "TransRate already run"
	fi
	echo

	#BUSCO
	if [ ! -d ${outputIDBAtran}/run_BUSCO* ]; then
		echo "Running BUSCO on ${species} ${sample} on `date`"
		cd ${outputIDBAtran}
		python3 $busco -o BUSCO2_${sample} -i contig.fa -l $odb9 -m tran -c 15
		cd $WD
	else
		echo "BUSCO already run"
	fi
	echo

	echo "Finished ${species} ${sample} in IDBA-tran on `date`"
	echo

#Oases
	echo "__________________________________________________________"
	if [ ! -f ${outputOases}/${species}"_"${sample}Merged/transcripts.fa ]; then
	#Determining insert size using bamtools on read mapped by transrate
		echo "Determining insert size for velvet/oases"
		insert=$(bamtools stats -insert -in ${bampath}/left.norm.fq.right.norm.fq.Trinity.bam | grep Average | cut -d" " -f6 | sed 's|\..*||')
		echo "Insert size is ${insert}"
		
	#Starting assembly using the oases python script
		echo "Starting assembly of ${species} ${sample} in Oases on `date`"
		mkdir -p ${outputOases}
		
		python $oases \
		-m 27 -M 87 -s 10 -o ${outputOases}/${species}"_"${sample} \
		-d " -shortPaired -strand_specific -fastq -separate ${left} ${right} " -p " -ins_length ${insert} -min_trans_lgth 200 " &> 02_Assemblies/${species}"_"${sample}"_oases.log" 
		
		echo "Finished on `date`"
	else
		echo "Oases assembly already done for ${species} ${sample}"
	fi
	echo

	#Transrate
	if [ ! -d ${outputOases}/${species}"_"${sample}Merged/transrate_1.0.1_${sample}_oases ]; then
		echo "Running TransRate on ${species} ${sample} on `date`"
		${transrate1} --assembly=${outputOases}/${species}"_"${sample}Merged/transcripts.fa \
			--left=${left} \
			--right=${right} \
			--threads=15 --output=${outputOases}/${species}"_"${sample}Merged/transrate_1.0.1_${sample}_oases
	else
		echo "TransRate already run"
	fi
	echo

	#BUSCO
	if [ ! -d ${outputOases}/${species}"_"${sample}Merged/run_BUSCO* ]; then
		echo "Running BUSCO on ${sample} on `date`"
		cd ${outputOases}/${species}"_"${sample}Merged/
		sed 's|\/|_|g' transcripts.fa > transcripts_busco.fa
		python3 $busco -o BUSCO2_${sample} -i transcripts_busco.fa -l $odb9 -m tran -c 15
		cd $WD
	else
		echo "BUSCO already run"
	fi
	echo
	
	echo "Finished processing ${sample} in Oases on `date`"
	echo
done

echo
echo "=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*="
echo "Finished all analyses for ${species}"
echo "=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*="
