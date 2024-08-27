#!/bin/bash
LOGDIRECTORY="/var/log/Shelllogs"
FILENAME=$(echo $0|cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d+%H-%M-%S)
LOGFILE="$LOGDIRECTORY/$FILENAME-$TIMESTAMP.log"

R="\e[32m"
Y="\e[33m"
N="\e[0m"

USER=$(id -u)

mkdir -p $LOGDIRECTORY

CHECK_ROOT()
{
    if [ $USER -ne 0 ]
    then
     echo  -e "you cant install as $R you dnt have req priviliges $N"| tee -a $LOGFILE
     exit 1
     fi
}
USAGE(){
    echo -e "$R USAGE $0 package1, package 2...$N" 
    exit 1
}
VALIDATE()
{
    if [ $1 -eq 0 ]
    then 
        echo -e "$R $2  SUCCESS $N"| tee -a $LOGFILE
    else 
        echo -e "$Y $2  FAILED $N"| tee -a $LOGFILE
    fi
}

CHECK_ROOT

if [ $# -eq 0 ]
    then 
    USAGE
fi

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Validating mysql installation"
systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Validating mysql enabling"
systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Validating mysql Starting"
mysql_secure_installation --set-root-pass ExpenseApp@1&>>$LOGFILE
VALIDATE $? "Validating Changing root paswword"
