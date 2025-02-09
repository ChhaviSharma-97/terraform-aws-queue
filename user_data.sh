#!/bin/bash

yum update -y
amazon-linux-extras install epel -y
yum install erlang -y
yum install rabbitmq-server -y
rabbitmq-plugins enable rabbitmq_management
systemctl enable rabbitmq-server
systemctl start rabbitmq-server
systemctl stop rabbitmq-server
truncate -s 0  /var/lib/rabbitmq/.erlang.cookie
echo "XAIFUIBJAVHSEZOKOMHD" >>  /var/lib/rabbitmq/.erlang.cookie 
systemctl start rabbitmq-server
export USERNAME="$(aws ssm get-parameter --name /${environment_name}/rabbit/USERNAME --with-decryption --output text --query Parameter.Value --region ${region})"
echo "$USERNAME"
export PASS="$(aws ssm get-parameter --name /${environment_name}/rabbit/PASSWORD --with-decryption --output text --query Parameter.Value --region ${region})"
echo "$PASS"
sudo rabbitmqctl add_user "$USERNAME" "$PASS"
sudo rabbitmqctl set_user_tags admin administrator
sudo rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
sleep 10s
sudo rabbitmq-plugins enable rabbitmq_management
sudo systemctl restart rabbitmq-server
