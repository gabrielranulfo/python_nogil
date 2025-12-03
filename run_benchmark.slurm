#!/bin/bash

#SBATCH --job-name=artigo_nogil
#SBATCH --partition=draco
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=4
#SBATCH --time=03:30:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

# Carregar módulos necessários (ajuste conforme seu ambiente)
# module load docker  # Descomente se necessário

# Definir diretório de trabalho
WORKDIR=$(pwd)
cd $WORKDIR

echo "=========================================="
echo "Iniciando benchmark Python 3.14 GIL vs NOGIL"
echo "Data: $(date)"
echo "Diretório: $WORKDIR"
echo "=========================================="

# Verificar se Docker está disponível
if ! command -v docker &> /dev/null; then
    echo "ERRO: Docker não encontrado!"
    exit 1
fi

# Verificar se docker compose está disponível
if ! docker compose version &> /dev/null; then
    echo "ERRO: docker compose não encontrado!"
    exit 1
fi

# Construir as imagens (se necessário)
echo ""
echo "=========================================="
echo "Construindo imagens Docker..."
echo "=========================================="
docker compose build

if [ $? -ne 0 ]; then
    echo "ERRO: Falha ao construir imagens Docker!"
    exit 1
fi

# Criar diretórios para resultados
mkdir -p results logs

# ============================================
# EXECUTAR BENCHMARK COM GIL
# ============================================
echo ""
echo "=========================================="
echo "Executando benchmark COM GIL"
echo "Início: $(date)"
echo "=========================================="

# Subir container COM GIL e executar benchmark
docker compose run --rm \
    -e SCALE_FACTOR=1.0 \
    python314-gil \
    bash -c "cd /root/polars-benchmark && export SCALE_FACTOR=1.0 && ./run.sh"

GIL_EXIT_CODE=$?

if [ $GIL_EXIT_CODE -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "Benchmark COM GIL concluído com sucesso!"
    echo "Fim: $(date)"
    echo "=========================================="
else
    echo ""
    echo "=========================================="
    echo "ERRO: Benchmark COM GIL falhou (código: $GIL_EXIT_CODE)"
    echo "Fim: $(date)"
    echo "=========================================="
fi

# ============================================
# EXECUTAR BENCHMARK SEM GIL (NOGIL)
# ============================================
echo ""
echo "=========================================="
echo "Executando benchmark SEM GIL (NOGIL)"
echo "Início: $(date)"
echo "=========================================="

# Subir container SEM GIL e executar benchmark
docker compose run --rm \
    -e SCALE_FACTOR=1.0 \
    python314-nogil \
    bash -c "cd /root/polars-benchmark && export SCALE_FACTOR=1.0 && ./run.sh"

NOGIL_EXIT_CODE=$?

if [ $NOGIL_EXIT_CODE -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "Benchmark SEM GIL concluído com sucesso!"
    echo "Fim: $(date)"
    echo "=========================================="
else
    echo ""
    echo "=========================================="
    echo "ERRO: Benchmark SEM GIL falhou (código: $NOGIL_EXIT_CODE)"
    echo "Fim: $(date)"
    echo "=========================================="
fi

# ============================================
# RESUMO FINAL
# ============================================
echo ""
echo "=========================================="
echo "RESUMO DA EXECUÇÃO"
echo "=========================================="
echo "Benchmark COM GIL:    $([ $GIL_EXIT_CODE -eq 0 ] && echo 'SUCESSO' || echo 'FALHOU')"
echo "Benchmark SEM GIL:    $([ $NOGIL_EXIT_CODE -eq 0 ] && echo 'SUCESSO' || echo 'FALHOU')"
echo "Data final: $(date)"
echo "=========================================="

# Código de saída: 0 se ambos sucederam, 1 caso contrário
if [ $GIL_EXIT_CODE -eq 0 ] && [ $NOGIL_EXIT_CODE -eq 0 ]; then
    exit 0
else
    exit 1
fi

