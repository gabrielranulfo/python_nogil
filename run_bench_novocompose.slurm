#!/bin/bash

#SBATCH --job-name=polars_benchmark
#SBATCH --partition=draco
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=60G
#SBATCH --time=20:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
ulimit -v $((60 * 1024 * 1024))

# Limpar tudo antes de começar

export SPARK_DRIVER_MEMORY='40g'
export SPARK_EXECUTOR_MEMORY='10g'

export imagem="polars-benchmark-32c60g"
export escala=50.0

echo "Limpando cache Docker..."
docker system prune -a --volumes -f
docker builder prune -af

# Remover containers e imagens antigas
docker compose down --rmi all --volumes --remove-orphans

# Remover imagem específica se existir
docker rmi $imagem:latest 2>/dev/null || true

# Construir sem cache e forçar pull das layers base
echo "Construindo imagem sem cache..."
DOCKER_BUILDKIT=1 docker build \
    --no-cache \
    --pull \
    --force-rm \
    -t $imagem:latest .

# Executar
echo "Executando benchmark..."
docker compose run --rm \
    -e SCALE_FACTOR=$escala \
    -e comando="make run-pyspark run-polars run-pandas run-duckdb run-dask" \
    -e SPARK_DRIVER_MEMORY=$SPARK_DRIVER_MEMORY \
    -e SPARK_EXECUTOR_MEMORY=$SPARK_EXECUTOR_MEMORY \
    $imagem bash -c "cd /root/polars-benchmark && ./run.sh"

#docker compose run --rm \
#  -e SCALE_FACTOR=$escala \
#  -e comando="make run-polars" \
#  $imagem \
#  bash -c "cd /root/polars-benchmark && ./run.sh"

