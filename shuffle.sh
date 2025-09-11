#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "Uso: $0 --seed SEED"
	echo "Embaralha as linhas da entrada, preservando o cabeçalho, com semente reprodutível."
	exit 1
fi

mapfile -t input

header="${input[0]}"
echo "$header"

#tira 1° linha (header)
input=("${input[@]:1}")

#imprime linha 1 por uma e usa o shuffle para misturar
printf "%s\n" "${input[@]:1}" | shuf --random-source=<(echo "$2")

for ((i = 0; i < ${#input[@]}; i++)); do
	echo "${input[$i]}"
done
