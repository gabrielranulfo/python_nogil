#!/bin/bash
#SBATCH --job-name=polars_benchmark_16c60g_scale10
#SBATCH --partition=draco
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=60G
#SBATCH --time=20:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
ulimit -v $((60 * 1024 * 1024))

echo "Slurm CPUs: $SLURM_CPUS_PER_TASK"
echo "Slurm Memória: $SLURM_MEM_PER_NODE"

export escala=10.0
export rep=50
export imagem="polars-benchmark-16c60g"

for ((i=1; i<=rep; i++))
do
    echo "Execução $i/$rep"

    docker compose run --rm \
      -e SCALE_FACTOR=$escala \
      $imagem \
      bash -c "cd /root/polars-benchmark && ./run.sh"

    if [ $i -lt $rep ]; then
        sleep 30
    fi
done
