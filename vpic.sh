#!/usr/bin/env bash

module purge
module load gcc/7.3.0 openmpi likwid

export OMP_NUM_THREADS=1
RESULTS="${HOME}/memsys19-skylake/results"
mkdir -p ${RESULTS}

cd /home/jlee/memsys19-skylake/vpic/
mkdir -p skylake
cd skylake
cmake ..
make clean
make -j

# vpic weak scaling for skylake modes, nppc in lpic_weak should be 32768
bin/vpic lpi_weak.cxx
for p in 1 24 48 72 96
do
    srun -n $p likwid-perfctr -g ENERGY   ./lpi_weak.Linux &> ${RESULTS}/vpic_weak_scaling.$p.ENERGY
    srun -n $p likwid-perfctr -g FLOPS_DP ./lpi_weak.Linux &> ${RESULTS}/vpic_weak_scaling.$p.FLOPS_DP
    srun -n $p likwid-perfctr -g MEM      ./lpi_weak.Linux &> ${RESULTS}/vpic_weak_scaling.$p.MEM
    srun -n $p likwid-perfctr -g L3CACHE  ./lpi_weak.Linux &> ${RESULTS}/vpic_weak_scaling.$p.L3CACHE
done


# vpic strong scaling for skylake modes
declare -A npccranks
npccranks[8192]=96
npccranks[16384]=72
npccranks[32768]=48
npccranks[65536]=24
npccranks[131072]=1

for i in "${!npccranks[@]}"
do
    bin/vpic strongscaling-$i.cxx
    srun -n "${npccranks[$i]}" likwid-perfctr -g ENERGY   ./strongscaling-"$i".Linux &> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.ENERGY
    srun -n "${npccranks[$i]}" likwid-perfctr -g FLOPS_DP ./strongscaling-"$i".Linux &> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.FLOPS_DP
    srun -n "${npccranks[$i]}" likwid-perfctr -g MEM      ./strongscaling-"$i".Linux &> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.MEM
    srun -n "${npccranks[$i]}" likwid-perfctr -g L3CACHE  ./strongscaling-"$i".Linux &> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.L3CACHE
done
