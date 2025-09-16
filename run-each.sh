#!/bin/bash
set -euo pipefail

if [ "$#" -lt 1 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	echo "7. run-each.sh"
	echo "Executa um comando substituindo placeholders {col} pelos valores."
	echo
	echo "Exemplo de uso:"
	echo "  \$ run-each.sh --cmd 'echo Rodando A={A} B={B}' --log logs/exp.log"
	echo
	echo "Entrada (stdin):"
	echo "A B"
	echo "1 x"
	echo "2 y"
	echo
	echo "Saída (stdout):"
	echo "Rodando A=1 B=x"
	echo "Rodando A=2 B=y"
fi

mapfile -t input

coms=("$@")

aux=0
for com in "${coms[@]}"; do
	if [ "$com" = "--cmd" ]; then
		comando="${coms[$((aux + 1))]}"
	elif [ "$com" = "--log" ]; then
		arquivo="${coms[$((aux + 1))]}"
	fi
	aux=$((aux + 1))
done

IFS=$'\t' read -r -a headers <<<"${input[0]}"

if [ "$comando" ] && [ "$arquivo" ]; then
	#clean arquivo
	: >"$arquivo"

	for ((i = 1; i < ${#input[@]}; i++)); do
		IFS=$'\t' read -r -a content <<<"${input[i]}"

		cmd_exec="$comando"

		# Substitui cada {COL} pelo valor correspondente
		for ((j = 0; j < ${#headers[@]}; j++)); do
			col="${headers[$j]}"
			val="${content[$j]}"
			cmd_exec="${cmd_exec//\{$col\}/$val}"
		done

		# Executa comando
		echo "$cmd_exec" | tee -a "$arquivo"
	done

else
	echo "Falta paramêtros!"
	exit 1
fi
