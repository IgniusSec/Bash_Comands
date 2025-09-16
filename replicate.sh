#!/bin/bash

set -euo pipefail

if [ "$#" -ne 2 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	echo "Uso: $0 --n N"
	echo "Replica cada linha da entrada N vezes, adicionando a coluna 'rep' (1..N)."
	exit 1
fi

mapfile -t input

echo -e "${input[0]}\trep"

if [ "$1" = "--n" ]; then
	for ((j = 1; j < ${#input[@]}; j++)); do
		for ((i = 1; i <= $2; i++)); do
			echo -e "${input[$j]}\t$i"
		done
	done
fi
