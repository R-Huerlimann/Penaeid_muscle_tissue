#!/bin/bash

#script to run RCorrecter on samples

source /etc/profile.d/modules.sh
module load jellyfish

for R1 in 2_Merged/*_R1*;do
	nohup perl /Software/rcorrector/run_rcorrector.pl -k 31 -t 1 -1 ${R1} -2 ${R1/_R1/_R2} -od 3_Corrected &> 3_Corrected/"${R1/2_Merged\//}".log &
done
