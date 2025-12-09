#!/bin/bash

#SBATCH --job-name=polars_benchmark
#SBATCH --partition=draco
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=4
#SBATCH --time=03:30:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

# docker compose down --rmi all --volumes --remove-orphans

docker compose build

docker compose run --rm -e SCALE_FACTOR=1.0 polars-benchmark bash -c "cd /root/polars-benchmark && export SCALE_FACTOR=1.0 && ./run.sh"
