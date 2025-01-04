#!/bin/bash

#Find whether the user is having root permission or not
#Add colours for better User interface
#Create Log foler
#Create validate function to validate every step

UserID=$(id -u)

R="\[e31m"
G="\[e32m"
Y="\[e33m"
N="\[e0m"
mkdir -p /var/log/expense.logs


Log_folder="/var/log/expense.logs"
Log_file=$(echo "$0" | cut -d"." f1)
Timestamp=$(echo "+%d-%m-%Y-%H-%M-%S")
Log_file_name="$Log_folder/$Log_file-$Timestamp.log"

Validate(){
    if [ $1 -ne 0 ]; then
        echo "$2 ...$R Failure $R"
        exit 1
    else
        echo "$2 ...$G Success $G"
    fi
}

Check_root(){
    if [ UserID -ne 0]; then
        echo -e " $R Error: You should have root access to run this script $R"
        exit 1
    fi
}

echo "Script is running at: $Timestamp" &>>$Log_file_name

dnf install mysql-server -y &>>$Log_file_name
Validate $? "Installing Mysql" 

systemctl enable mysqld &>>$Log_file_name
Validate $? "Starting Mysql"

systemctl start mysqld &>>$Log_file_name
Validate $? "Starting Mysql"

systemctl status mysqld &>>$Log_file_name
Validate $? "Starting Mysql"

mysql -h database-server.nithinlearning.site -u root -pExpenseApp@1 -e 'show databases;' &>>$Log_file_name

if[ $? -ne 0 ] then 
echo "Mysql root user setup was not successfull">>$Log_file_name
mysql_secure_installation --set-root-pass ExpenseApp@1
Validate $? "Mysql root user setup was ...."
else
echo "MySQL Root password already setup.....$Y Skipping $Y"
fi







