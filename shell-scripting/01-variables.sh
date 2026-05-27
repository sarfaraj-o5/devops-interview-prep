#!/bin/bash

NAME=Sachin
## $NAME OR ${NAME} -- this is comment

echo "Hello, ${NAME} how are you?"
echo "What are doing $NAME"
echo "Good Morning $NAME"

## date

DATE=$(date +%F)

echo "Hello, Today's date is ${DATE}"