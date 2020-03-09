provider "aws" {
  region  = "us-east-1"
  version = "2.52.0"
}

module "vpc" {
  source = "../../modules/vpc"

  name               = var.cluster_name
  cidr_block         = var.cidr_block
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

module "iam" {
  source = "../../modules/iam"

  eks_service_role_name = "eksServiceRole-${var.cluster_name}"
  eks_node_role_name    = "EKSNode-${var.cluster_name}"
}

module "cluster" {
  source = "../../modules/cluster"

  name = var.cluster_name

  # So we can access the k8s API from CI/dev
  endpoint_public_access = true

  vpc_config = module.vpc.config
  iam_config = module.iam.config

  aws_auth_role_map = [
    {
      username = aws_iam_role.test_role.name
      rolearn  = aws_iam_role.test_role.arn
      groups   = ["system:masters"]
    }
  ]
}

module "node_group" {
  source = "../../modules/asg_node_group"

  cluster_config = module.cluster.config

  labels = {
    "danieltefera08.com/plinth-test-environment" = var.cluster_name
  }

  taints = {
    "plinth" = "test:PreferNoSchedule"
  }
}
