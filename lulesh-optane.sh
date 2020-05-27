#!/usr/bin/env bash

module load likwid

export OMP_NUM_THREADS=1
RESULTS="${HOME}/sc20-benchmarks/lulesh-optane-results"
mkdir -p ${RESULTS}

cd ~/sc20-benchmarks/LULESH
make clean
make -j

 # LULESH weak scaling
 size=320
 for p in 64 27 8 1
 do
     echo `timedatectl` &>> ${RESULTS}/lulesh_weak_scaling.$p.ENERGY
     likwid-mpirun -np $p -g ENERGY   ./lulesh2.0 -s ${size} -i 10 &>> ${RESULTS}/lulesh_weak_scaling.$p.ENERGY
     echo `timedatectl` &>> ${RESULTS}/lulesh_weak_scaling.$p.ENERGY
 #    echo `timedatectl`&>> ${RESULTS}/lulesh_weak_scaling.$p.FLOPS_DP
 #    likwid-mpirun -np $p -g FLOPS_DP ./lulesh2.0 -s ${size} -i 10 &>> ${RESULTS}/lulesh_weak_scaling.$p.FLOPS_DP
 #    echo `timedatectl`&>> ${RESULTS}/lulesh_weak_scaling.$p.FLOPS_DP
     echo `timedatectl`&>> ${RESULTS}/lulesh_weak_scaling.$p.MEM
     likwid-mpirun -np $p -g MEM      ./lulesh2.0 -s ${size} -i 10 &>> ${RESULTS}/lulesh_weak_scaling.$p.MEM
     echo `timedatectl`&>> ${RESULTS}/lulesh_weak_scaling.$p.MEM
     # echo `timedatectl`&>> ${RESULTS}/lulesh_weak_scaling.$p.L3CACHE
     # likwid-mpirun -np $p -g L3CACHE  ./lulesh2.0 -s ${size} -i 10 &>> ${RESULTS}/lulesh_weak_scaling.$p.L3CACHE
     # echo `timedatectl`&>> ${RESULTS}/lulesh_weak_scaling.$p.L3CACHE
 done

# LULESH strong scaling
declare -A procsize
procsize[1]=1024
procsize[8]=512
procsize[27]=344
 procsize[64]=256

for p in "${!procsize[@]}"
do
    echo `timedatectl` &> ${RESULTS}/lulesh_strong_scaling.$p.ENERGY
    likwid-mpirun -np $p -g ENERGY   ./lulesh2.0 -s ${procsize[$p]} -i 10 &>> ${RESULTS}/lulesh_strong_scaling.$p.ENERGY
    echo `timedatectl` &>> ${RESULTS}/lulesh_strong_scaling.$p.ENERGY
 #   echo `timedatectl` &> ${RESULTS}/lulesh_strong_scaling.$p.FLOPS_DP
 #   likwid-mpirun -np $p -g FLOPS_DP ./lulesh2.0 -s ${procsize[$p]} -i 10 &>> ${RESULTS}/lulesh_strong_scaling.$p.FLOPS_DP
 #   echo `timedatectl` &>> ${RESULTS}/lulesh_strong_scaling.$p.FLOPS_DP
    echo `timedatectl` &> ${RESULTS}/lulesh_strong_scaling.$p.MEM
    likwid-mpirun -np $p -g MEM      ./lulesh2.0 -s ${procsize[$p]} -i 10 &>> ${RESULTS}/lulesh_strong_scaling.$p.MEM
    echo `timedatectl` &>> ${RESULTS}/lulesh_strong_scaling.$p.MEM
    # echo `timedatectl` &> ${RESULTS}/lulesh_strong_scaling.$p.L3CACHE
    # likwid-mpirun -np $p -g L3CACHE  ./lulesh2.0 -s ${procsize[$p]} -i 10 &>> ${RESULTS}/lulesh_strong_scaling.$p.L3CACHE
    # echo `timedatectl` &>> ${RESULTS}/lulesh_strong_scaling.$p.L3CACHE
done
