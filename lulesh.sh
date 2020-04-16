#!/usr/bin/env bash

module load openmpi likwid

export OMP_NUM_THREADS=1
RESULTS="${HOME}/memsys19-skylake/results"
mkdir -p ${RESULTS}

cd ~/memsys19-benchmarks/LULESH
make clean
make -j

# LULESH weak scaling
size=320
for p in 64 27 8 1
do
    srun -n $p --oversubscribe likwid-perfctr -g ENERGY   ./lulesh2.0 -s ${size} &> ${RESULTS}/lulesh_weak_scaling.$p.ENERGY
    srun -n $p --oversubscribe likwid-perfctr -g FLOPS_DP ./lulesh2.0 -s ${size} &> ${RESULTS}/lulesh_weak_scaling.$p.FLOPS_DP
    srun -n $p --oversubscribe likwid-perfctr -g MEM      ./lulesh2.0 -s ${size} &> ${RESULTS}/lulesh_weak_scaling.$p.MEM
    srun -n $p --oversubscribe likwid-perfctr -g L3CACHE  ./lulesh2.0 -s ${size} &> ${RESULTS}/lulesh_weak_scaling.$p.L3CACHE
done

# LULESH strong scaling
declare -A procsize
procsize[1]=1024
procsize[8]=768
procsize[27]=512
procsize[64]=256

for p in "${!procsize[@]}"
do
    srun -n $p --oversubscribe likwid-perfctr -g ENERGY   ./lulesh2.0 -s ${procsize[$p]} &> ${RESULTS}/lulesh_strong_scaling.$p.ENERGY
    srun -n $p --oversubscribe likwid-perfctr -g FLOPS_DP ./lulesh2.0 -s ${procsize[$p]} &> ${RESULTS}/lulesh_strong_scaling.$p.FLOPS_DP
    srun -n $p --oversubscribe likwid-perfctr -g MEM      ./lulesh2.0 -s ${procsize[$p]} &> ${RESULTS}/lulesh_strong_scaling.$p.MEM
    srun -n $p --oversubscribe likwid-perfctr -g L3CACHE  ./lulesh2.0 -s ${procsize[$p]} &> ${RESULTS}/lulesh_strong_scaling.$p.L3CACHE
done
