
# The EKS Cluster
resource "aws_eks_cluster" "eks_master" {
  name     = "${var.ENVIRONMENT}-eks-master"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = module.eks_vpc.public_subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_service_policy,
  ]

  tags = {
    Name = "${var.ENVIRONMENT}-eks-master"
  }
}

# The EKS Worker Nodes
resource "aws_eks_node_group" "eks_worker" {
  cluster_name    = aws_eks_cluster.eks_master.name
  node_group_name = "${var.ENVIRONMENT}-eks-worker"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = module.eks_vpc.public_subnets

  scaling_config {
    desired_size = var.ENVIRONMENT == "Production" ? 2 : 1
    max_size     = 4
    min_size     = 1
  }

  
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_policy,
  ]
}