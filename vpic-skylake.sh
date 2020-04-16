#!/usr/bin/env bash

module purge
module load cmake gcc/7.3.0 openmpi/3.1.3-gcc_7.3.0 likwid

export OMP_NUM_THREADS=1
RESULTS="${HOME}/hpca-skylake/results"
mkdir -p ${RESULTS}

cd ~/memsys19-benchmarks/vpic/
#mkdir -p skylake
cd build
rm -rf *
cmake ..
make clean
make -j

## vpic weak scaling for skylake modes, nppc in lpic_weak should be 32768
#bin/vpic ../sample/lpi_weak.cxx
#for p in 96 # 1 24 48 72 96
#do
#    echo `timedatectl` &> ${RESULTS}/vpic_weak_scaling.$p.ENERGY
#    srun -n $p -N 4 -p skylake-gold likwid-perfctr -g ENERGY   ./lpi_weak.Linux &>> ${RESULTS}/vpic_weak_scaling.$p.ENERGY
#    echo `timedatectl` &>> ${RESULTS}/vpic_weak_scaling.$p.ENERGY
#    echo `timedatectl` &> ${RESULTS}/vpic_weak_scaling.$p.FLOPS_DP
#    srun -n $p -N 4 -p skylake-gold likwid-perfctr -g FLOPS_DP ./lpi_weak.Linux &>> ${RESULTS}/vpic_weak_scaling.$p.FLOPS_DP
#    echo `timedatectl` &>> ${RESULTS}/vpic_weak_scaling.$p.FLOPS_DP
#    echo `timedatectl` &> ${RESULTS}/vpic_weak_scaling.$p.MEM
#    srun -n $p -N 4 -p skylake-gold likwid-perfctr -g MEM      ./lpi_weak.Linux &>> ${RESULTS}/vpic_weak_scaling.$p.MEM
#     echo `timedatectl` &>> ${RESULTS}/vpic_weak_scaling.$p.MEM
#    # echo `timedatectl` &> ${RESULTS}/vpic_weak_scaling.$p.L3CACHE
#    # srun -n $p -N 4 -p skylake-gold likwid-perfctr -g L3CACHE  ./lpi_weak.Linux &>> ${RESULTS}/vpic_weak_scaling.$p.L3CACHE
#    # echo `timedatectl` &>> ${RESULTS}/vpic_weak_scaling.$p.L3CACHE
#done


# vpic strong scaling for skylake modes
declare -A npccranks
# npccranks[16384]=72
# npccranks[32768]=48
#npccranks[131072]=1

#for i in "${!npccranks[@]}"
#do
#    bin/vpic ../sample/strongscaling-${npccranks[$i]}.cxx
#    echo `timedatectl` &> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.MEM
#    srun -n "${npccranks[$i]}" -N 4 -p skylake-gold likwid-perfctr -g MEM      ./strongscaling-"${npccranks[$i]}".Linux &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.MEM
#    echo `timedatectl` &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.MEM
#done

npccranks[65536]=24
#npccranks[8192]=96

for i in 65536
do
    bin/vpic ../sample/strongscaling-${npccranks[$i]}.cxx
#    echo `timedatectl` &> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.ENERGY
#    srun -n "${npccranks[$i]}" -N 4 -p skylake-gold likwid-perfctr -g ENERGY   ./strongscaling-"${npccranks[$i]}".Linux &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.ENERGY
#    echo `timedatectl` &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.ENERGY
#    echo `timedatectl` &> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.FLOPS_DP
#    srun -n "${npccranks[$i]}" -N 4 -p skylake-gold likwid-perfctr -g FLOPS_DP ./strongscaling-"${npccranks[$i]}".Linux &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.FLOPS_DP
#    echo `timedatectl` &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.FLOPS_DP
    echo `timedatectl` &> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.MEM
    srun -n "${npccranks[$i]}" -N 4 -p skylake-gold likwid-perfctr -g MEM      ./strongscaling-"${npccranks[$i]}".Linux &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.MEM
    echo `timedatectl` &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.MEM
    # echo `timedatectl` &> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.L3CACHE
    # srun -n "${npccranks[$i]}" -N 4 -p skylake-gold likwid-perfctr -g L3CACHE  ./strongscaling-"${npccranks[$i]}".Linux &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.L3CACHE
    # echo `timedatectl` &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.L3CACHE
done
