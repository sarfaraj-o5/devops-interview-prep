#!/bin/bash

# df -hT |grep -vE 'tmpfs|Filesystem' | awk '{print $6 " " $1}' 

# df -hT |grep -vE 'tmpfs|Filesystem' | awk '{print $6 " " $1}' | cut -d "%" -f1

DISK_THRESHOLD=10
DISK_USAGE=$(df -hT |grep -vE 'tmpfs|Filesystem' | awk '{print $6 " " $1}')

while IFS= read line;
do 
    usage=$(echo $line | cut -d "%" -f1)
    echo "usage: $usage"
    rm -rf $line
done <<< "$DISK_USAGE"