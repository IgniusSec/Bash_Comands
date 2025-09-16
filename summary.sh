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
	echo "10. summary.sh"
	echo "Calcula média e contagem (n) de uma coluna numérica, agrupando por colunas categóricas."
	echo
	echo "Exemplo de uso:"
	echo "  \$ summary.sh --by A,B --col acc"
	echo
	echo "Entrada (stdin):"
	echo "A B acc"
	echo "1 x 0.80"
	echo "1 x 0.90"
	echo "2 y 0.95"
	echo
	echo "Saída (stdout):"
	echo "A B acc_mean n"
	echo "1 x 0.85 2"
	echo "2 y 0.95 1"
	exit 0
fi

mapfile -t input

IFS=$'\t' read -r -a headers <<<"${input[0]}"

coms=("$@")

aux=0
for com in "${coms[@]}"; do
	if [ "$com" = "--by" ]; then
		columsHeader="${coms[$((aux + 1))]}"
	elif [ "$com" = "--col" ]; then
		columContent="${coms[$((aux + 1))]}"
	fi
	aux=$((aux + 1))
done

aux=0
for ((i = 0; i < ${#headers[@]}; i++)); do
	if verify_exists "$columsHeader" "${headers[$i]}"; then
		pos[aux]="$i"
		aux=$((aux + 1))
	else
		echo "Uma das colunas é inválida!" >&2
	fi
done

for ((i = 0; i < ${#headers[@]}; i++)); do
	if [ "${headers[$i]}" = "$columContent" ]; then
		num_pos=$i
		break
	fi
done

declare -A med
declare -A count

for ((i = 1; i < ${#input[@]}; i++)); do
	IFS=$'\t' read -r -a content <<<"${input[$i]}"

	key=""
	for ((j = 0; j < ${#pos[@]}; j++)); do
		idx=${pos[$j]}
		if [ -n "$key" ]; then
			key="${key}|${content[$idx]}"
		else
			key="${content[$idx]}"
		fi
	done

	val="${content[$num_pos]}"
	if [[ "$val" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
		med["$key"]=$(echo "${med[$key]:-0} + $val" | bc -l)
		count["$key"]=$((${count[$key]:-0} + 1))
	else
		echo "Aviso: valor inválido '$val' na linha $((i + 1)) ignorado." >&2
	fi
done

echo -e "${columsHeader//,/$'\t'}\t${columContent}_mean\tn"

for k in "${!med[@]}"; do
	IFS='|' read -r -a parts <<<"$k"
	mean=$(echo "scale=10; ${med[$k]} / ${count[$k]}" | bc -l)
	for part in "${parts[@]}"; do
		printf "%s\t" "$part"
	done
	LC_NUMERIC=C printf "%.2f\t%d\n" "$mean" "${count[$k]}"
done | sort
