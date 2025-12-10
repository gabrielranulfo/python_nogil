#!/bin/bash

#SBATCH --job-name=artigo_nogil
#SBATCH --partition=draco
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=4
#SBATCH --time=03:30:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

#docker compose down --rmi all --volumes --remove-orphans

docker compose build

#altere o run.sh do polars-benchmarch de modo a executar apenas a pandas pois o artigo vai usar apenas pandas

docker compose run --rm -e SCALE_FACTOR=1.0 python314-gil bash -c "cd /root/polars-benchmark && export SCALE_FACTOR=1.0 && ./run.sh"

docker compose run --rm -e SCALE_FACTOR=1.0 python314-nogil bash -c "cd /root/polars-benchmark && export SCALE_FACTOR=1.0 && ./run.sh"
