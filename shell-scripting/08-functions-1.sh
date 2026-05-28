#!/bin/bash

USERID=$(id -u)

# check user is root or not

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root user access"
    exit 1
fi

# this is generic function, we need to pass arguments
VALIDATE() {
    if [ $1 -ne 0 ] # $? exit codes staus store/reveives on this $1 or passing exit code in $1
    then
        echo "$2 ... FAILED" ##  
    else   
        echo "$2 ... SUCCESS"
    fi    
}

apt install git -y

VALIDATE $? "GIT Installation"  ## exit status of above function/cmd

apt install vimmmm -y

VALIDATE $? "VIM Installation"

apt install wget -y

VALIDATE $? "WGET Installation"

apt install net-tools -y

VALIDATE $? "NET-TOOLS"


# VALIDATE $? # exit code of above cmd
# VALIDATE $? "GIT Installation"
                $2

# sh functions-1.sh git ## passing arguments
#                   $1  
