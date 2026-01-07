#!/bin/bash
#SBATCH --job-name=polars_benchmark_32c60g_scale01
#SBATCH --partition=draco
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=60G
#SBATCH --time=10:00:00
#SBATCH --output=polars_benchmark_32c60g_scale01_%x_%j.out
#SBATCH --error=polars_benchmark_32c60g_scale01_%x_%j.err
ulimit -v $((60 * 1024 * 1024))

echo "Slurm CPUs: $SLURM_CPUS_PER_TASK"
echo "Slurm Memória: $SLURM_MEM_PER_NODE"

export escala=1.0
export rep=50
export imagem="polars-benchmark-32c60g"

for ((i=1; i<=rep; i++))
do
    echo "Execução $i/$rep"

    docker compose run --rm \
      --cpuset-cpus 0-31 \
      --memory 60g \
      -e SCALE_FACTOR=$escala \
      $imagem \
      bash -c "cd /root/polars-benchmark && ./run.sh"

    if [ $i -lt $rep ]; then
        sleep 30
    fi
done
