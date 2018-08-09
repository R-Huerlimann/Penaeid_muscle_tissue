#!/bin/bash

source /etc/profile.d/modules.sh
module load hmmer
module load blast
module load python/3.5.1

#BUSCO2_start.sh input.fa #cores

ARG2=${2-5}

nohup python3 /Software/busco/BUSCO.py -o "BUSCO2_"$1 -i $1 -l /Databases/BUSCO_db/arthropoda_odb9 -m tran -c $ARG2
