#!/bin/bash

# Shell Script 07
# Automating Email Alerts with a Bash Script! Ö
# Simple but powerful Bash script for sending customizable email alerts  . Let¾s break it down step by
# step and understand its purpose and functionality:
# This script saves time ó and ensures consistency across alert emails.
# Input Arguments:
# TO_TEAM: Team to notify (used to replace the placeholder in the template).
# ALERT_TYPE: The type of alert (e.g., Critical, Warning).
# BODY: The main content of the alert message.
# TO_ADDRESS: The recipient's email address.
# SUBJECT: The subject of the email.

# ARGS
# $1- TO_TEAM: team to notify(placeholder in template)
# $2- ALERT_TYPE: type of alert(e.g. critical, warning)
# $3-BODY: main content of the alert message
# $4-TO_ADDRESS: recipient email address
# $5- SUBJECT: email subject

TO_TEAM=$1
ALERT_TYPE=$2
BODY=$3

# escape special chars in the BODY content 
ESCAPE_BODY=$(printf'%s\n' "BODY" | sed -e 's/11\/$*-^11/11819/')

TO_ADDRESS=$4
SUBJECT=$5

# Replace placeholders in the HTML template
FINAL_BODY=$(sed -e "s/TO_TEAM/$TO_TEAM/g"\ 
        -e "s/ALERT_TYPE/$ALERT_TYPE/g"\
        -e "s/BODY/$ESCAPE_BODY/g" 19.Mail_template.html)

# send the emaili using the 'mail' cmd
echo "$FINAL_BODY" | mail -s "$(echo -e "$SUBJECT\nContent-Type: text/html")"
"$TO_ADDRESS"