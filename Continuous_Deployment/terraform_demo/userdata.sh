#!/bin/sh
set -x
# output log of userdata to /var/log/user-data.log
apt-get update -y
apt-get install apache2 -y
ufw allow 'Apache Full'
ufw status
apt-get install wget
wget https://s3.eu-central-1.amazonaws.com/nvplayground/demo-0.0.1-SNAPSHOT.jar
apt-get install openjdk-8-jdk -y
java -jar demo-0.0.1-SNAPSHOT.jar

