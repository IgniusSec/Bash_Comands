#!/bin/bash

if [ "$#" -lt 1 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	echo "Uso: $0 ARQUIVO_LOG"
	echo "Copia a entrada (stdin) para stdout e também grava em arquivo com timestamp."
	echo "Exemplo: $0 logs/raw.log"
	exit 1
fi

mapfile -t input

timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

for lines in "${input[@]}"; do
	echo -e "$timestamp\t$lines" >>"$1"
done
