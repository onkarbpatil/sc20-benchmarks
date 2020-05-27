#!/usr/bin/env bash

#module purge
module load likwid null

set -x
export OMP_NUM_THREADS=1
RESULTS="${HOME}/sc20-benchmarks/vpic-optane-results"
mkdir -p ${RESULTS}

cd ~/sc20-benchmarks/vpic/
cd build
rm -rf *
cmake ..
make clean
make -j

# vpic weak scaling for optane modes, nppc in lpic_weak should be 32768
bin/vpic ../sample/lpi_weak.cxx
for p in 1 24 48 72 96
do
    echo `timedatectl` &>> ${RESULTS}/vpic_weak_scaling.$p.ENERGY
    likwid-mpirun -np $p -g ENERGY   ./lpi_weak.Linux &>> ${RESULTS}/vpic_weak_scaling.$p.ENERGY
    echo `timedatectl` &>> ${RESULTS}/vpic_weak_scaling.$p.ENERGY
#    echo `timedatectl` &>> ${RESULTS}/vpic_weak_scaling.$p.FLOPS_DP
#    likwid-mpirun -np $p -g FLOPS_DP ./lpi_weak.Linux &>> ${RESULTS}/vpic_weak_scaling.$p.FLOPS_DP
#    echo `timedatectl` &>> ${RESULTS}/vpic_weak_scaling.$p.FLOPS_DP
    echo `timedatectl` &>> ${RESULTS}/vpic_weak_scaling.$p.MEM
    likwid-mpirun -np $p -g MEM      ./lpi_weak.Linux &>> ${RESULTS}/vpic_weak_scaling.$p.MEM
    echo `timedatectl` &>> ${RESULTS}/vpic_weak_scaling.$p.MEM
#    # echo `timedatectl` &>> ${RESULTS}/vpic_weak_scaling.$p.L3CACHE
#    # likwid-mpirun -np $p -g L3CACHE  ./lpi_weak.Linux &>> ${RESULTS}/vpic_weak_scaling.$p.L3CACHE
#    # echo `timedatectl` &>> ${RESULTS}/vpic_weak_scaling.$p.L3CACHE
done


# vpic strong scaling for optane modes
declare -A npccranks
npccranks[8192]=96
npccranks[16384]=72
npccranks[32768]=48
npccranks[65536]=24
npccranks[131072]=1

for i in "${!npccranks[@]}"
do
    bin/vpic ../sample/strongscaling-${npccranks[$i]}.cxx
     echo `timedatectl` &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.ENERGY
     likwid-mpirun -np "${npccranks[$i]}" -g ENERGY   ./strongscaling-"${npccranks[$i]}".Linux &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.ENERGY
     echo `timedatectl` &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.ENERGY
   # echo `timedatectl` &>  ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.FLOPS_DP
   # likwid-mpirun -np "${npccranks[$i]}" -g FLOPS_DP ./strongscaling-"${npccranks[$i]}".Linux &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.FLOPS_DP
   # echo `timedatectl` &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.FLOPS_DP
     echo `timedatectl` &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.MEM
     likwid-mpirun -np "${npccranks[$i]}" -g MEM      ./strongscaling-"${npccranks[$i]}".Linux &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.MEM
     echo `timedatectl` &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.MEM
    # echo `timedatectl` &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.L3CACHE
    # likwid-mpirun -np "${npccranks[$i]}" -g L3CACHE  ./strongscaling-"${npccranks[$i]}".Linux &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.L3CACHE
    # echo `timedatectl` &>> ${RESULTS}/vpic_strong_scaling.$i.${npccranks[$i]}.L3CACHE
done
