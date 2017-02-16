#!/bin/bash
DBNAME=''
DBINSTANCE=''
DBUSER=''
DBPASS=''

aws rds create-db-instance --db-instance-identifier $DBINSTANCE --db-instance-class db.t2.micro --db-name $DBNAME --engine mysql --master-username $DBUSER --master-user-password $DBPASS --allocated-storage 5  --vpc-security-group-ids sg-922e43ee --no-publicly-accessible
echo "Launching db...please wait....\n"
while true
do
  DBHOST=$(aws rds describe-db-instances | jq .DBInstances[].Endpoint.Address | tr -d '""' | grep $DBINSTANCE)
  if [ $? -eq 0 ]; then
	break;
  else
	echo "retrying after 3 sec..."
	sleep 3
  fi
done

cat <<EOF > wp-setup.sh
#!/bin/bash
cd /var/www/html/
cp --preserve wp-config-sample.php wp-config.php
sed -i 's/localhost/$DBHOST/g' wp-config.php 
sed -i 's/username_here/$DBUSER/g' wp-config.php 
sed -i 's/password_here/$DBPASS/g' wp-config.php 
sed -i 's/database_name_here/$DBNAME/g' wp-config.php 
EOF
aws ec2 run-instances --image-id ami-b5b671a3 --count 1 --instance-type t2.micro  --key-name awolde --security-groups "allow ssh and http" --user-data file://wp-setup.sh
