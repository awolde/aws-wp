#!/bin/bash

#set up variables
echo "Setting up variables ..."
dbname="ndettmer-wp-db2"
dbuser="ndettmer"
dbpass="1839brook"


#Launch RDS using defined variables
echo "Launching RDS instance"
aws rds create-db-instance --db-instance-identifier $dbname \ --allocated-storage 5 --db-instance-class db.t2.micro --engine mysql \ --master-username $dbuser --master-user-password $dbpass

while true
  do

dbhost=$(aws rds describe-db-instances | jq .DBInstances[0].Endpoint.Address)
if [ $? -eq 0]; then
       echo "The new database address is $dbhost"
       break;
else
       echo "retrying after 3 seconds..."
       sleep 3
fi
done



#Now launch a new instance of the saved image: ami-f01285e6
echo "launching new EC2 instance ..."
#Launch instance and get new instance ID
ecid=`aws ec2 run-instances --image-id ami-f01285e6 --count 1 --instance-type t2.micro --key-name RichDT --security-groups "allow-ssh-and-http" | jq .Instances[0].InstanceId`

#Wait for public DNS to get set up
echo "Waiting for instances public DNS ..."
sleep 1m

#Get Instance[0].PublicDnsName
newEcHost=`aws ec2 describe-instances --instance-id $ecid | jq .Instances[0].PublicDnsName`

#Now update the instance wp-config values ...
ssh ubuntu@$newEcHost
cd /var/www/html/
cp –p wp-config-sample.php wp-config.php
sed -i 's/localhost/$dbhost/g' wp-config.php 
sed -i 's/database_name_here/$dbname/g' wp-config.php 
sed -i 's/username_here/$dbuser/g' wp-config.php 
sed -i 's/password_here/$dbpass/g' wp-config.php 




 






