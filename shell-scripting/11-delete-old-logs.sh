#!/bin/bash

PATH=/root/devops-interview-prep/shell-scripting/logs

DATE=$(/usr/bin/date +%F)
LOG_FILE="$DATE.log"

INPUT=$(/usr/bin/find /root/devops-interview-prep/shell-scripting/logs -name "*.log" -type f -mtime +14
)

while IFS= read line;
do
    echo "Deleting log file: $line"
done <<< "$INPUT"

