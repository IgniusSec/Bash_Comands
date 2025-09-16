#!/bin/bash

set -euo pipefail

if [ "$#" -lt 1 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	echo "Uso: $0 CONDICAO"
	echo "Filtra linhas da entrada (stdin) por condição simples de coluna:"
	echo "  - Igualdade: COL==VAL"
	echo "  - Regex:     COL~/regex/"
	echo
	echo "Exemplo:"
	echo "  $0 A==1"
	echo "  $0 B~/x/"
	exit 1
fi

mapfile -t input

IFS=$'\t' read -r -a headers <<<"${input[0]}"

if [[ "$1" == *"=="* ]]; then
	col="${1%%==*}"
	val="${1#*==}"
	op="eq"
elif [[ "$1" == *"~/"* ]]; then
	col="${1%%\~*}"
	val="${1#*~/}"
	val="${val%/}"
	op="regex"
else
	echo "Condição inválida: use COL==VAL ou COL~/regex/"
	exit 1
fi

indexCol=-1
for ((i = 0; i < "${#headers[@]}"; i++)); do
	if [ "${headers[$i]}" = "$col" ]; then
		indexCol=$i
		break
	fi
done

if [ "$indexCol" -eq -1 ]; then
	echo "Coluna não encontrada: $col"
	exit 1
fi

echo "${input[0]}"

for ((i = 1; i < ${#input[@]}; i++)); do
	IFS=$'\t' read -r -a content <<<"${input[$i]}"

	if [ "$op" = "eq" ]; then
		if [ "${content[$col_index]}" = "$val" ]; then
			echo "${input[$i]}"
		fi
	else
		if [ "${content[$indexCol]}" = "$val" ]; then
			echo "${input[$i]}"
		fi
	fi
done
