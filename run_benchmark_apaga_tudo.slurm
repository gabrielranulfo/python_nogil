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

'''
ulimit -v $((16 * 1024 * 1024)) 

echo "SLURM_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK"
echo "SLURM_NTASKS=$SLURM_NTASKS"
lscpu | grep "^CPU(s)"
sleep 340
'''


echo "Limpando cache Docker..."
docker system prune -a --volumes -f
docker builder prune -af

# Remover containers e imagens antigas
docker compose down --rmi all --volumes --remove-orphans

# Remover imagem específica se existir
docker rmi polars-benchmark:latest 2>/dev/null || true

# Construir sem cache e forçar pull das layers base
echo "Construindo imagem sem cache..."
DOCKER_BUILDKIT=1 docker build \
    --no-cache \
    --pull \
    --force-rm \
    -t polars-benchmark:latest .

# Executar
echo "Executando benchmark..."
docker compose run --rm -e SCALE_FACTOR=10.0 polars-benchmark bash -c "cd /root/polars-benchmark && export SCALE_FACTOR=10.0 && ./run.sh"

