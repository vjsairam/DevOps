## Using your preferred infrastructure provisioning tool and Amazon Web Services (AWS) as a cloud provider, please complete the following subtasks:

- create a new VPC with CIDR 172.16.0.0
- create two new subnets with CIDR 172.16.1.0/24 and 172.16.2.0/24 in two different availability zones
- create 5 new ec2 instances based on Ubuntu 18.04 (bionic)
- deploy the following Java application on these instances - https://s3.eu-central-1.amazonaws.com/nvplayground/demo-0.0.1-
SNAPSHOT.jar
- create a load balancer for the Java application on port 80
