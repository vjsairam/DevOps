#!/bin/sh
set -x
# output log of userdata to /var/log/user-data.log
sudo apt-get update -y
sudo apt-get install apache2 -y
sudo ufw allow 'Apache Full'
sudo ufw status
sudo apt-get install wget
wget https://s3.eu-central-1.amazonaws.com/nvplayground/demo-0.0.1-SNAPSHOT.jar
sudo apt-get install openjdk-8-jdk -y
java -jar demo-0.0.1-SNAPSHOT.jar

