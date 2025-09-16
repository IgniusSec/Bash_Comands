#!/bin/bash
set -euo pipefail

if [ "$#" -lt 1 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	echo "9. grep-metric.sh"
	echo "Extrai métricas no padrão chave=valor."
	echo
	echo "Exemplo de uso:"
	echo "  \$ grep-metric.sh --key acc"
	echo
	echo "Entrada (stdin):"
	echo "run 0001: acc=0.91 tempo=5s"
	echo "run 0002: acc=0.87 tempo=6s"
	echo
	echo "Saída (stdout):"
	echo "acc 0.91"
	echo "acc 0.87"
	exit 0
fi

mapfile -t input

for ((i = 0; i < ${#input[@]}; i++)); do
	IFS=' ' read -r -a line <<<"${input[i]}"
	for content in "${line[@]}"; do
		if [[ "$content" == *"$2="* ]]; then
			value="${content#*=}"
			echo -e "$2\t$value"
		fi
	done
done
