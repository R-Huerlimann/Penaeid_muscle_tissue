#!/bin/bash

#script to merge the samples run on two separate lanes

N=40

for L004_R1 in *L004_R1*;do

	((i=i%N)); ((i++==0)) && wait

	#generate new name "merged"
	merged=$(echo $L004_R1 | sed 's|_.*||')

	#merge both R1
	echo "Merging $R1"
	cat ${L004_R1} ${L004_R1/L004/L005} > "$merged"_R1.fastq &	
	
	#merge both R2
    cat ${L004_R1/_R1/_R2} ${L004_R1/L004_R1/L005_R2} > "$merged"_R2.fastq &

done
