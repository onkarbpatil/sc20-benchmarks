#!/usr/bin/env bash

module purge
module load gcc/7.3.0 openmpi/3.1.3-gcc_7.3.0 likwid

export OMP_NUM_THREADS=1
RESULTS="${HOME}/sc20-benchmarks/lulesh-skylake-results"
mkdir -p ${RESULTS}

cd ~/sc20-benchmarks/LULESH
make clean
make -j

# LULESH weak scaling
size=320

# p=64
# echo `timedatectl`&>> ${RESULTS}/lulesh_weak_scaling.$p.L3CACHE
# srun -n $p -N 4 -p skylake-gold -w cn[610-613] likwid-perfctr -g L3CACHE  ./lulesh2.0 -s ${size} -i 1000 &>> ${RESULTS}/lulesh_weak_scaling.$p.L3CACHE
# echo `timedatectl`&>> ${RESULTS}/lulesh_weak_scaling.$p.L3CACHE

 for p in 27 8 1 64
 do
     echo `timedatectl` &>> ${RESULTS}/lulesh_weak_scaling.$p.ENERGY
     srun -n $p -N 4 -p skylake-gold -w cn[610-613] likwid-perfctr -g ENERGY   ./lulesh2.0 -s ${size} -i 10 &>> ${RESULTS}/lulesh_weak_scaling.$p.ENERGY
     echo `timedatectl`&>> ${RESULTS}/lulesh_weak_scaling.$p.ENERGY
    # echo `timedatectl`&>> ${RESULTS}/lulesh_weak_scaling.$p.FLOPS_DP
    # srun -n $p -N 4 -p skylake-gold -w cn[610-613] likwid-perfctr -g FLOPS_DP ./lulesh2.0 -s ${size} -i 10 &>> ${RESULTS}/lulesh_weak_scaling.$p.FLOPS_DP
    # echo `timedatectl`&>> ${RESULTS}/lulesh_weak_scaling.$p.FLOPS_DP
     echo `timedatectl`&>> ${RESULTS}/lulesh_weak_scaling.$p.MEM
     srun -n $p -N 4 -p skylake-gold -w cn[610-613] likwid-perfctr -g MEM      ./lulesh2.0 -s ${size} -i 10 &>> ${RESULTS}/lulesh_weak_scaling.$p.MEM
     echo `timedatectl`&>> ${RESULTS}/lulesh_weak_scaling.$p.MEM
    # echo `timedatectl`&>> ${RESULTS}/lulesh_weak_scaling.$p.L3CACHE
    # srun -n $p -N 4 -p skylake-gold -w cn[610-613] likwid-perfctr -g L3CACHE  ./lulesh2.0 -s ${size} -i 10 &>> ${RESULTS}/lulesh_weak_scaling.$p.L3CACHE
    # echo `timedatectl`&>> ${RESULTS}/lulesh_weak_scaling.$p.L3CACHE
 done

# LULESH strong scaling
declare -A procsize
procsize[1]=1024
procsize[8]=512
procsize[27]=344
procsize[64]=256

# echo `timedatectl` &> ${RESULTS}/lulesh_strong_scaling.1.ENERGY
# srun -n 1 -N 1 -p skylake-gold -w cn610 likwid-perfctr -g ENERGY   ./lulesh2.0 -s 1024 -i 10 &>> ${RESULTS}/lulesh_strong_scaling.1.ENERGY
# echo `timedatectl` &>> ${RESULTS}/lulesh_strong_scaling.1.ENERGY
# echo `timedatectl` &> ${RESULTS}/lulesh_strong_scaling.1.FLOPS_DP
# srun -n 1 -N 1 -p skylake-gold -w cn610 likwid-perfctr -g FLOPS_DP ./lulesh2.0 -s 1024 -i 10 &>> ${RESULTS}/lulesh_strong_scaling.1.FLOPS_DP
# echo `timedatectl` &>> ${RESULTS}/lulesh_strong_scaling.1.FLOPS_DP
# echo `timedatectl` &> ${RESULTS}/lulesh_strong_scaling.1.MEM
# srun -n 1 -N 1 -p skylake-gold -w cn610 likwid-perfctr -g MEM      ./lulesh2.0 -s 1024 -i 10 &>> ${RESULTS}/lulesh_strong_scaling.1.MEM
# echo `timedatectl` &>> ${RESULTS}/lulesh_strong_scaling.1.MEM

for p in "${!procsize[@]}"
do
    echo `timedatectl` &> ${RESULTS}/lulesh_strong_scaling.$p.ENERGY
    srun -n $p -N 4 -p skylake-gold -w cn[610-613] likwid-perfctr -g ENERGY   ./lulesh2.0 -s ${procsize[$p]} -i 10 &>> ${RESULTS}/lulesh_strong_scaling.$p.ENERGY
    echo `timedatectl` &>> ${RESULTS}/lulesh_strong_scaling.$p.ENERGY
#    echo `timedatectl` &> ${RESULTS}/lulesh_strong_scaling.$p.FLOPS_DP
#    srun -n $p -N 4 -p skylake-gold -w cn[610-613] likwid-perfctr -g FLOPS_DP ./lulesh2.0 -s ${procsize[$p]} -i 10 &>> ${RESULTS}/lulesh_strong_scaling.$p.FLOPS_DP
#    echo `timedatectl` &>> ${RESULTS}/lulesh_strong_scaling.$p.FLOPS_DP
    echo `timedatectl` &> ${RESULTS}/lulesh_strong_scaling.$p.MEM
    srun -n $p -N 4 -p skylake-gold -w cn[610-613] likwid-perfctr -g MEM      ./lulesh2.0 -s ${procsize[$p]} -i 10 &>> ${RESULTS}/lulesh_strong_scaling.$p.MEM
    echo `timedatectl` &>> ${RESULTS}/lulesh_strong_scaling.$p.MEM
    # echo `timedatectl` &>> ${RESULTS}/lulesh_strong_scaling.$p.L3CACHE
    # srun -n $p -N 4 -p skylake-gold -w cn[610-613] likwid-perfctr -g L3CACHE  ./lulesh2.0 -s ${procsize[$p]} -i 10 &>> ${RESULTS}/lulesh_strong_scaling.$p.L3CACHE
    # echo `timedatectl` &>> ${RESULTS}/lulesh_strong_scaling.$p.L3CACHE
done
