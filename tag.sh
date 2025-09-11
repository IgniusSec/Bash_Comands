#!/bin/bash

if [ "$#" -lt 1 ]; then
	echo "Usage: ./tag.sh dataset=mnist"
	exit
fi

mapfile -t input

#pegar cada um das headers e printa os headers

IFS=" " read -r -a coms <<<"$*"

echo -n -e "${input[0]}\t"
for ((i = 0; i < ${#coms[@]}; i++)); do
	header[$i]="${coms[$i]%%=*}"
	echo -n -e "${header[$i]}\t"
	content[$i]="${coms[$i]#*=}"
done
echo

for ((i = 1; i < ${#input[@]}; i++)); do
	echo -n -e "${input[$i]}\t"
	for ((j = 0; j < ${#content[@]}; j++)); do
		echo -n -e "${content[$j]}\t"
	done
	echo
done
echo
