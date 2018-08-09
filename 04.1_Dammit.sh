#!/bin/bash

### Environment ###
source /etc/profile.d/modules.sh
module load hmmer
module load blast
module load parallel

### how to run ###
#nohup 04.1_Dammit.sh Pmono 15 

### Directories ###
WD=$PWD

### Species ###
species_list=( Pmono Plong Mensi Plati Psemi Mende Pescu Fmerg Lvana )

### Running Dammit ###
cd 04_Annotation/
dammit annotate ${1}_final.fasta --busco-group arthropoda -n ${1}_Transcript --n_threads ${2} --verbosity 2 --full
