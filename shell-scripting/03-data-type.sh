#!/bin/bash

## i need to write a program to addition of 2 numbers
# 2+2 = 4
# NUMBER1=100
# NUMBER2=200
# NUMBER1=something
# NUMBER2=amar
NUMBER1=$1
NUMBER2=$2

RESULT=$((NUMBER1+NUMBER2))

echo "Addtion Result = ${RESULT}"