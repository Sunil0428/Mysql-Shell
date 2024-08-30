#!/bin/bash
LOGDIRECTORY="/var/log/shellogs"
FILE=$( echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d:%H:%M:%s)
LOGFILE="$LOGDIRECTORY/$FILE_$TIMESTAMP.log"

echo " $LOGFILE"

USER=$(id -u)
R="\e[32m"
Y="\e[33m"
N="\e[0m"

CHECK_ROOT()
{
    if [ $USER -ne 0 ]
    then
     echo  -e "you cant install as $R you dnt have req priviliges $N" 
     exit 1
     fi
}
VALIDATE()
{
    if [ $1 -eq 0 ]
    then 
        echo -e "$R $2 is SUCCESS $N"
    else 
        echo -e "$Y $2 is not FAILED $N"
    fi
}
CHECK_ROOT

dnf module disable nodejs -y &>>LOGFILE
VALIDATE $? "Disabling nodejs"

dnf module enable nodejs:20 -y &>>LOGFILE
VALIDATE $? "Enabling nodejs"