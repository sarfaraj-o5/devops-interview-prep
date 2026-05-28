#!/bin/bash

USERID=$(id -u)
DATE=$(date +"%F-%H-%M-%S")
LOG_FILE="$DATE.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
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

# 10-not installed 20-installed
CHECK_INSTALLED(){
    IS_INSTALLED=10
    apt -q list --installed $1 &>/dev/null
    if [ $? -eq 0 ]
    then    
        IS_INSTALLED=20
    fi
    return $IS_INSTALLED
}

for PACKAGE in $@ # git vim net-tools wget
do
    IS_INSTALLED $PACKAGE
    return_value=$?
    echo "return value from function: $return_value"
    if [ $return_value -ne 20 ]
    then
        echo "$PACKAGE ... Not Installed"
        apt install $PACKAGE -y &>>LOG_FILE
        VALIDATE $? "$PACKAGE Installation"
    else
        echo -e "$PACKAGE ... $Y Installed Already $N"
    fi
done
