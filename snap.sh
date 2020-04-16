#!/usr/bin/env bash

module load openmpi likwid

export OMP_NUM_THREADS=1
RESULTS="${HOME}/memsys19-skylake/results-skylake"
mkdir -p ${RESULTS}

cd /home/jlee/memsys19-skylake/SNAP/ports/snap-c
make -j clean
make -j


srun -n 4 ./snap --fi ../../qasnap/sample/inp --fo out
# # SNAP strong scaling
# for p in 1 8 16 32
# do
#     srun -n $p likwid-perfctr -g ENERGY   ./snap --fi ${p}_strong --fo ${RESULTS}/snap_strong_scaling.$p.ENERGY    &> ${RESULTS}/snap_strong_scaling.$p.ENERGY.likwid
#     srun -n $p likwid-perfctr -g FLOPS_DP ./snap --fi ${p}_strong --fo ${RESULTS}/snap_strong_scaling.$p.FLOPS_DP  &> ${RESULTS}/snap_strong_scaling.$p.FLOPS_DP.likwid
#     srun -n $p likwid-perfctr -g MEM      ./snap --fi ${p}_strong --fo ${RESULTS}/snap_strong_scaling.$p.MEM       &> ${RESULTS}/snap_strong_scaling.$p.MEM.likwid
#     srun -n $p likwid-perfctr -g L3CACHE  ./snap --fi ${p}_strong --fo ${RESULTS}/snap_strong_scaling.$p.L3CACHE   &> ${RESULTS}/snap_strong_scaling.$p.L3CACHE.likwid
# done

# # SNAP weak scaling
# for p in 1 8 16 32
# do
#     srun -n $p likwid-perfctr -g ENERGY   ./snap --fi ${p}_weak --fo ${RESULTS}/snap_weak_scaling.$p.ENERGY    &> ${RESULTS}/snap_weak_scaling.$p.ENERGY.likwid
#     srun -n $p likwid-perfctr -g FLOPS_DP ./snap --fi ${p}_weak --fo ${RESULTS}/snap_weak_scaling.$p.FLOPS_DP  &> ${RESULTS}/snap_weak_scaling.$p.FLOPS_DP.likwid
#     srun -n $p likwid-perfctr -g MEM      ./snap --fi ${p}_weak --fo ${RESULTS}/snap_weak_scaling.$p.MEM       &> ${RESULTS}/snap_weak_scaling.$p.MEM.likwid
#     srun -n $p likwid-perfctr -g L3CACHE  ./snap --fi ${p}_weak --fo ${RESULTS}/snap_weak_scaling.$p.L3CACHE   &> ${RESULTS}/snap_weak_scaling.$p.L3CACHE.likwid
# done
