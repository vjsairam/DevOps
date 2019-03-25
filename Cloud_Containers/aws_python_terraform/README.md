**Overview**

The project is to demonstrate the use of AWS Fargate, which alows you to run containers without having to manage servers or clusters. It can currently be used on top of AWS Elastic Container Service (ECS) with support for Kubernetes (EKS).  Bringing Serverless to Microservice is the main objective of this project, where all the underlying resources are managed by AWS Fargate and the whole platform is provisioned with Terraform. 

> AWS Fargate is a compute engine for Amazon ECS that allows you to run containers without having to manage servers or clusters. With AWS Fargate, you no longer have to provision, configure, and scale clusters of virtual machines to run containers. This removes the need to choose server types, decide when to scale your clusters, or optimize cluster packing. AWS Fargate removes the need for you to interact with or think about servers or clusters. Fargate lets you focus on designing and building your applications instead of managing the infrastructure that runs them.

This is a simple project of deploying an docker image hosted on AWS Elastic Container Repository(ECR) to ECS Fargate. The stack can be changed with the respective terraform variables and modules.  The overall objective is to setup up a webserver running on AWS Fargate, accessible through an Application Load Balancer. 


**Project Setup**

Clone the project and navigate to the aws_python_terraform project, 

    
    git clone https://github.com/vjsairam/DevOps.git
    cd Cloud_Containers/aws_python_terraform/
    

*The project assumes that the user has the best understanding on the [Best Practices for Managing AWS Access Keys](https://docs.aws.amazon.com/general/latest/gr/aws-access-keys-best-practices.html) or Using any third party tools like Vault.* 

1. Create Backend state for Terraform State - Create a S3 bucket in the region that you are going to run this project. The bucket name is referenced in [vars.tf](https://github.com/vjsairam/DevOps/blob/master/Cloud_Containers/aws_python_terraform/terraform/vars.tf), remember the bucket name is unique and replace it with your bucket name. 

2. Start with terraform init to provision the infrastructure,
`aws_python_terraform/terraform/]$ terraform init`

3. AWS Elastic Container registry (ECR) is used to store docker images, if you are using any private registry or docker registry, please skip this step and configure the terraform parameters accordingly. Create a respository and make a note of the repository URL in the output, 
`aws_python_terraform/terraform/]$ terraform apply --target aws_ecr_repository.myapp`
*You can export the repository URL to push the docker images or directly use this URL*

4. Build and Push Images to AWS,
 
	i. If you are using AWS ec2-instance for this project, then you can execute this command directly, 
    
    ii. If you are using your personal computer, then you will need AWS CLI tools to push images to ECR. Refer to this [page](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) for installation details,

    `Cloud_Containers/aws_python_terraform/terraform/]$  $(aws ecr get-login --region us-east-1 --no-include-email)`

    iii. Use the below command to build, tag and deploy, 

        aws_python_terraform/demo/]$  docker build -t myapp . 
        aws_python_terraform/demo/]$  docker tag myapp <include_myapp-repo>:latest
        aws_python_terraform/demo/]$  docker push <include_myapp-repo>:latest 

	iv. Use the below command to apply the changes, 
    
    	aws_python_terraform/terraform/]$ terraform apply
       
    v. The terraform changes would take a couple of minutes to make the changes live and the DNS name shall be displayed as the output. 

NOTE: Use `terraform destroy` to delete all the resources that was created. 


**Configuration Files Explained**

Terraform Files - https://github.com/vjsairam/DevOps/tree/master/Cloud_Containers/aws_python_terraform/terraform

1. Vars - https://github.com/vjsairam/DevOps/blob/master/Cloud_Containers/aws_python_terraform/terraform/vars.tf

	***TODO*** - Include the unique S3 bucket name in the same region that was created. 

2. Cloudwatch -  https://github.com/vjsairam/DevOps/blob/master/Cloud_Containers/aws_python_terraform/terraform/cloudwatch.tf
 
	***TODO / Improvements*** - To run the service at regurlar intervals, include [Scheduled tasks](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/scheduled_tasks.html) / include it in the terraform configuration file. 

Docker/Application Files - https://github.com/vjsairam/DevOps/tree/master/Cloud_Containers/aws_python_terraform/demo

1. Application File - https://github.com/vjsairam/DevOps/blob/master/Cloud_Containers/aws_python_terraform/demo/app.py

    ***TODO*** - Include the URL that needs to be scraped. 

2. DockerFile - https://github.com/vjsairam/DevOps/blob/master/Cloud_Containers/aws_python_terraform/demo/Dockerfile

    ***TODO / Improvements*** - This is a simple project explaining the scraping of a website, the DockerFile and the Application File can be extended to any operations.

