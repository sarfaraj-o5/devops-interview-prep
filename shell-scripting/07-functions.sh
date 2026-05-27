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

echo "Installing wget"
apt install wget -y

if [ $? -ne 0 ]
then
    echo "wget installation is failed"
else   
    echo "wget installation is success"
fi

echo "Installing net-tools"
apt install net-tools -y

if [ $? -ne 0 ]
then
    echo "net-tools installation is failed"
else   
    echo "net-tools installation is success"
fi

echo "Installing vim"
apt install vim -y

if [ $? -ne 0 ]
then
    echo "vim installation is failed"
else   
    echo "vim installation is success"
fi
