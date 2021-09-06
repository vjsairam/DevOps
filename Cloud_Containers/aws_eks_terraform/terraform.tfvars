aws-region           = "us-east-1"
cluster-name         = "development-cluster"
subnet_ids	         = ["subnet-0660d996aee78058d","subnet-0c16c66ad395f6f4a","subnet-0c6592eb737e76435"]
eks-cw-logging	     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
node_instance_type   = ["t3.medium"]
node-group-name      = ["development-pool-1"]
desired-capacity     = 2
max-size	         = 5
min-size             = 1
key_pair_name        = "development-cluster-key"
cluster_private_access = "true"
cluster_public_access = "false"



