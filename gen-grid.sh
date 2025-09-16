#!/bin/bash

if [ "$#" -ne 2 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	echo "Uso: $0 VAR1=val1,val2 VAR2=val1,val2"
	echo "Cada variável deve receber pelo menos dois valores separados por vírgula."
	exit 1
fi

var1="${1%%=*}"
IFS="," read -r -a array1 <<<"${1#*=}"
#content1="${1#*=}"

var2="${2%%=*}"
IFS="," read -r -a array2 <<<"${2#*=}"
#content2="${2#*=}"

echo -e "$var1\t$var2"

for ((i = ${array1[0]}; i <= ${array1[1]}; i++)); do
	for ((j = 0; j < ${#array2[@]}; j++)); do
		echo -e "$i\t${array2[j]}"
	done
done
