#!/bin/bash

NAME=$1
WISH=$2

echo "Hi ${NAME}, Good ${WISH}" 

# how to know how many args are passed

echo "Number of args passed are: $#"

echo "Number of args passed are: $@"  # to see all args passed 

#########################################

# echo "Please enter username"

# read -s USERNAME # invisible in cmd/prompt

# echo "User is: ${USERNAME}"

# echo "Please enter password"

# read -s PASSWORD

# echo "Password is: ${PASSWORD}"