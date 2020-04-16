#!/usr/bin/env bash

set -x

module load likwid

export OMP_NUM_THREADS=1
RESULTS="${HOME}/ipdps-memorymode/results"
mkdir -p ${RESULTS}

# likwid-mpirun -nperdomain N:1 -np 4 hostname

cd ~/ipdps2020-benchmarks/memsys19-benchmarks/AMG
make -j clean
make -j
cd test

declare -A P
P[1]="1 1 1"
P[24]="2 4 3"
P[48]="4 4 3"
P[72]="4 3 6"
P[96]="4 4 6"

# AMG weakscaling
for p in 1 24 48 72 96
do
    for t in ENERGY MEM #FLOPS_DP MEM L3CACHE
    do
	    echo `timedatectl` &>> ${RESULTS}/amg_weak_scaling-optane.$p.$t
        likwid-mpirun -np $p -g $t   ./amg -n 224 224 224 -P ${P[$p]} &>> ${RESULTS}/amg_weak_scaling-optane.$p.$t
	    echo `timedatectl` &>> ${RESULTS}/amg_weak_scaling-optane.$p.$t
    done
done

# AMG strong scaling
declare -A N
N[1]="768 768 768"
N[24]="384 192 256"
N[48]="192 192 256"
N[72]="192 256 128"
N[96]="192 192 128"

for p in "${!N[@]}"
do
    for t in ENERGY MEM #FLOPS_DP MEM L3CACHE
    do
	    echo `timedatectl` &>> ${RESULTS}/amg_strong_scaling-optane.$p.$t
        likwid-mpirun -np $p -g $t   ./amg -n ${N[$p]} -P ${P[$p]} &>> ${RESULTS}/amg_strong_scaling-optane.$p.$t
	    echo `timedatectl` &>> ${RESULTS}/amg_strong_scaling-optane.$p.$t
    done
done