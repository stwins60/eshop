module "eks_node_group" {
  source = "cloudposse/eks-node-group/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "2.x.x"

  instance_types        = ["t2.micro"]
  subnet_ids            = data.aws_subnet_ids.subnet_ids.ids
  min_size              = 1
  max_size              = 2
  desired_size          = 1
  cluster_name          = module.eks_blueprints.eks_cluster_id
  create_before_destroy = true
  kubernetes_version    = var.kubernetes_version == null || var.kubernetes_version == "" ? [] : [var.kubernetes_version]

  #   # Enable the Kubernetes cluster auto-scaler to find the auto-scaling group
  #   cluster_autoscaler_enabled = var.autoscaling_policies_enabled

  #   context = module.label.context

  # Ensure the cluster is fully created before trying to add the node group
#   module_depends_on = [module.eks_blueprints.kubernetes_config_map_id]
}