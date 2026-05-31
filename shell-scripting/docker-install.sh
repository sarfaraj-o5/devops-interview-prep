#!/bin/bash

set -eE -o functrace
failure() {
    local lineno=$1
    local msg=$2
    echo "Failed at $lineno: $msg"
}
trap 'failure ${LINENO} "$BASH_COMMAND"' ERR

USERID=$(id -u)
LOGFILE="docker-install.log"

R="\e[31m"
N="\e[0m"
G="\e[32m"

if [ $USERID -ne 0 ]
then
    echo -e "$R Please run this script with root access $N"
    exit 1
fi

yum install -y yum-utils &>>$LOGFILE
echo -e "yum-utils ... $G Insatlled $N"

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo &>>$LOGFILE
echo -e "Docker Repo ... $G Added $N"

yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y &>>$LOGFILE
echo "Docker Engine ... $G Installed $N"

systemctl start docker &>>$LOGFILE

systemctl enable docker &>>$LOGFILE

usermod -aG docker centos

echo "Docker installation completed, logout and login"