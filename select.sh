#!/bin/bash

verify_exists() {
	IFS=',' read -r -a arr <<<"$1"
	local comp="$2"
	for j in "${arr[@]}"; do
		if [ "$comp" == "$j" ]; then
			return 0
		fi
	done
	return 1
}

if [ "$#" -lt 1 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	echo "Uso: $0 COL1[,COL2,...]"
	echo "Seleciona colunas específicas da entrada (stdin) e imprime no stdout."
	exit 1
fi

mapfile -t input

IFS=$'\t' read -r -a headers <<<"${input[0]}"

aux=0

for ((i = 0; i < ${#headers[@]}; i++)); do
	if verify_exists "$1" "${headers[$i]}"; then
		pos[aux]="$i"
		aux=$((aux + 1))
	fi
done

for ((i = 0; i < ${#input[@]}; i++)); do
	IFS=$'\t' read -r -a content <<<"${input[$i]}"

	for ((j = 0; j < ${#pos[@]}; j++)); do
		echo -n -e "${content[${pos[$j]}]}\t"
	done
	echo
done
echo
