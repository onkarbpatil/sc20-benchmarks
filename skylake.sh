#/usr/bin/env bash

sbatch -N 4 --qos=long --time=2-00:00:00 amg-skylake.sh
sbatch -N 4 --qos=long --time=2-00:00:00 vpic-skylake.sh
sbatch -N 4 --qos=long --time=2-00:00:00 lulesh-skylake.sh
