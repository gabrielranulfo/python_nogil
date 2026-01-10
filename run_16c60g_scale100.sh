#!/bin/bash
#SBATCH --job-name=polars_benchmark_16c60g_scale100
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

export escala=100.0
export rep=50
export imagem="polars-benchmark-16c60g"

export POLARS_MAX_THREADS=16
export DASK_NUM_WORKERS=1
export DASK_THREADS_PER_WORKER=16
export OMP_NUM_THREADS=1  
export DUCKDB_THREADS=16
export DUCKDB_EXTERNAL_THREADS=16
export DUCKDB_ASYNC_IO_THREADS=8
export SPARK_EXECUTOR_CORES=16
export SPARK_EXECUTOR_INSTANCES=1
export SPARK_DRIVER_CORES=16
export SPARK_DEFAULT_PARALLELISM=128
export SPARK_SQL_SHUFFLE_PARTITIONS=128

for ((i=1; i<=rep; i++))
do
    echo "Execução $i/$rep"

    docker compose run --rm \
      -e SCALE_FACTOR=$escala \
      -e POLARS_MAX_THREADS=$POLARS_MAX_THREADS \
      -e OMP_NUM_THREADS=$OMP_NUM_THREADS \
      -e MKL_NUM_THREADS=$MKL_NUM_THREADS \
      -e DASK_NUM_WORKERS=$DASK_NUM_WORKERS \
      -e DASK_THREADS_PER_WORKER=$DASK_THREADS_PER_WORKER \
      -e DUCKDB_THREADS=$DUCKDB_THREADS \
      -e DUCKDB_EXTERNAL_THREADS=$DUCKDB_EXTERNAL_THREADS \
      -e DUCKDB_ASYNC_IO_THREADS=$DUCKDB_ASYNC_IO_THREADS \
      -e SPARK_EXECUTOR_CORES=$SPARK_EXECUTOR_CORES \
      -e SPARK_EXECUTOR_INSTANCES=$SPARK_EXECUTOR_INSTANCES \
      -e SPARK_DRIVER_CORES=$SPARK_DRIVER_CORES \
      -e SPARK_DEFAULT_PARALLELISM=$SPARK_DEFAULT_PARALLELISM \
      -e SPARK_SQL_SHUFFLE_PARTITIONS=$SPARK_SQL_SHUFFLE_PARTITIONS \
      $imagem \
      bash -c "cd /root/polars-benchmark && ./run.sh"

    if [ $i -lt $rep ]; then
        sleep 30
    fi
done
