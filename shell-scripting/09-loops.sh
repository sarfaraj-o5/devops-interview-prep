#!/bin/bash

USERID=$(id -u)
DATE=$(date +"%F-%H-%M-%S")
LOG_FILE="$DATE.log"
R="\e[31m"
G="\e[32m"
N="\e[0m"
#check user is root or not

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root user access"
    exit 1
fi

#this is a generic function, we need to pass arguments
VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

for PACKAGE in $@ # git vim net-tools wget
do
    apt install $PACKAGE -y
    VALIDATE $? "$PACKAGE Installation"
done
