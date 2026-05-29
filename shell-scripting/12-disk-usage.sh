#!/bin/bash

df -hT |grep -vE 'tmpfs|Filesystem' | awk '{print $6 " " $1}' 

df -hT |grep -vE 'tmpfs|Filesystem' | awk '{print $6 " " $1}' | cut -d $f1