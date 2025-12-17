#!/bin/bash

#docker system prune -a --volumes

#docker compose down --rmi all --volumes --remove-orphans

#docker compose build --force-rm --no-cache

docker compose build --force-rm

#docker compose build

docker compose run --rm -e SCALE_FACTOR=1.0 polars-benchmark bash -c "cd /root/polars-benchmark && export SCALE_FACTOR=1.0 && ./run.sh"
