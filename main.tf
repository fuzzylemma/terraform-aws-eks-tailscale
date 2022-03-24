data "aws_eks_cluster" "this" {
  name = var.eks_cluster_id
}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_id
}

provider "kubernetes" {
  host = data.aws_eks_cluster.this.endpoint
  token = data.aws_eks_cluster_auth.this.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
}

module "subnet_router" {
  source   = "./modules/tailscale-subnet-router"
  tailscale_auth_key = var.tailscale_auth_key
  region = var.region
}
