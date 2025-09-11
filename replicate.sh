#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "Usage: ./replicate.sh --n 2"
	exit
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
