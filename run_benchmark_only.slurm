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

for i in {1..50}
do
    echo "Execução $i/50"
    docker compose run --rm -e SCALE_FACTOR=10.0 polars-benchmark bash -c "cd /root/polars-benchmark && ./run.sh"

    if [ $i -lt 50 ]; then
        sleep 30
    fi
done