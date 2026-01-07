#!/bin/bash
echo "Iniciando todos os jobs de benchmark..."

# Nós / configurações
nodes=("8c60g" "16c60g" "32c60g")

# Sufixos de escala. '01' -> exibido como '1' para manter formato anterior; '10' -> exibido como '10'
scales=("01" "10")

for s in "${scales[@]}"; do
	# formato de exibição: "01" vira "1"
	display="$s"
	if [ "$s" = "01" ]; then
		display="1"
	fi

	for n in "${nodes[@]}"; do
		echo "############## Escala ${display} ${n} ##############" >> output/run/timings.csv
		echo "############## Escala ${display} ${n} ##############" >> output/run/memory_monitor.csv
		echo "############## Escala ${display} ${n} ##############" >> output/run/cpu_monitor.csv

		sbatch "run_${n}_scale${s}.sh"

		echo "############## Escala ${display} ${n} ##############" >> output/run/timings.csv
		echo "############## Escala ${display} ${n} ##############" >> output/run/memory_monitor.csv
		echo "############## Escala ${display} ${n} ##############" >> output/run/cpu_monitor.csv
	done
done