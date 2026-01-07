#!/bin/bash

#SBATCH --job-name=polars_benchmark
#SBATCH --partition=draco
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=10:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

# Limpar tudo antes de começar

export imagem="polars-benchmark-8c60g"
export escala=1.0

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
docker compose run --rm -e SCALE_FACTOR=$escala $imagem bash -c "cd /root/polars-benchmark && ./run.sh"

