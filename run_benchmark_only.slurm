#!/bin/bash

#SBATCH --job-name=polars_benchmark
#SBATCH --partition=draco
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=4
#SBATCH --time=10:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

#docker system prune -a --volumes

#docker compose down --rmi all --volumes --remove-orphans

#docker compose build --force-rm --no-cache

#rm -rf /home/users/grbcirillo/python_nogil/output

#docker compose build --no-cache

#docker build --no-cache --pull --force-rm -t polars-benchmark:latest .

#docker compose run --rm -e SCALE_FACTOR=1.0 polars-benchmark bash -c "cd /root/polars-benchmark && export SCALE_FACTOR=1.0 && ./run.sh"

#docker compose run --rm -e SCALE_FACTOR=1.0 polars-benchmark-8c60g bash -c "cd /root/polars-benchmark && export POLARS_MAX_THREADS=8 && ./run.sh"

export escala=1.0
export imagem="polars-benchmark-8c60g"

export POLARS_MAX_THREADS=8
export DASK_NUM_WORKERS=1
export DASK_THREADS_PER_WORKER=8
export OMP_NUM_THREADS=1  
export DUCKDB_THREADS=8
export DUCKDB_EXTERNAL_THREADS=8
export DUCKDB_ASYNC_IO_THREADS=4
export SPARK_EXECUTOR_CORES=8
export SPARK_EXECUTOR_INSTANCES=1
export SPARK_DRIVER_CORES=8
export SPARK_DEFAULT_PARALLELISM=64  # 8 cores * 8 partitions per core
export SPARK_SQL_SHUFFLE_PARTITIONS=64

export SPARK_DRIVER_MEMORY=8g
export SPARK_EXECUTOR_MEMORY=52g

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

#for i in {1..50}
#do
#    echo "Execução $i/50"
#    docker compose run --cpuset-cpus 0-7 --rm -e SCALE_FACTOR=10.0 polars-benchmark bash -c "cd /root/polars-benchmark && ./run.sh"

#    if [ $i -lt 50 ]; then
#        sleep 30
#    fi
#done