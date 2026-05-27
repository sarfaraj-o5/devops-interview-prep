#!/bin/bash

USERID=$(id -u)

# check user is root or not

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root user access"
    exit 1
fi

echo "Installing Git"
apt install git -y

if [ $? -ne 0 ]
then
    echo "Git installation is failed"
else   
    echo "Git installation is success"
fi
