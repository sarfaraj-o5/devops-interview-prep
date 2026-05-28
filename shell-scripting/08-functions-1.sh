#!/bin/bash

USERID=$(id -u)
DATE=$(date +"%F-%H-%M-%S")
LOG_FILE=$DATE
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
        echo "$2 ... FAILED" &>>$LOG_FILE
        exit 1  # it'll stop here
    else   
        echo "$2 ... SUCCESS" &>>$LOG_FILE
    fi    
}

apt install git -y &>>$LOG_FILE

VALIDATE $? "GIT Installation"  ## $2 exit status of above function/cmd

apt install vimmmm -y &>>$LOG_FILE

VALIDATE $? "VIM Installation"

apt install wget -y &>>$LOG_FILE

VALIDATE $? "WGET Installation"

apt install net-tools -y &>>$LOG_FILE

VALIDATE $? "NET-TOOLS"


# VALIDATE $? # exit code of above cmd
# VALIDATE $? "GIT Installation"
                $2

# sh functions-1.sh git ## passing arguments
#                   $1  
