module "eks_blueprints" {
  source             = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.0.2"
  cluster_version    = "1.21"
  vpc_id             = var.vpc
  private_subnet_ids = data.aws_subnet_ids.subnet_ids.ids

  managed_node_groups = {
    mg_m5 = {
      node_group_name = "eshop_nodegroup"
      instance_types  = ["t2.micro"]
      subnet_ids      = data.aws_subnet_ids.subnet_ids.ids
    }
  }
}


data "aws_subnet_ids" "subnet_ids" {
  vpc_id = data.aws_vpc.vpc.id
}

data "aws_subnet" "subnet" {
  for_each = data.aws_subnet_ids.subnet_ids.ids
  id       = each.value
}

data "aws_vpc" "vpc" {
  id = var.vpc
}
