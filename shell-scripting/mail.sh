#!/bin/bash

TO=#1
SUBJECT=$2
BODY_CONTENT=$3
NAME=$4
ALERT_TYPE=$2
template=""

final_content=$(sed -e "s/TEAM/$NAME/g" -e "s/BODY_CONTENT/$BODY_CONTENT/g" -e "s/ALERT_TYPE/$ALERT_TYPE/g" "$template")

echo "final_content: $final_content"