#!/bin/bash

USERID=$(id -u)
if [ $USERID -eq 0 ]
then
    echo "User has root access"
else    
    echo "You are not root user, Please run with root privilage."
    exit 1
fi

echo "Installing Git"

# yum install git -y
apt install git -y

if [ $? -eq 0 ]
then
    echo "Git installed successfully" # if this is success then linux consider overall script is success
else
    echo "Git is not installed"
    exit 1
fi


