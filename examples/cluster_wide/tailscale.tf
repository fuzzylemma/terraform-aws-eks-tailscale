module "tailscale_subnet_router" {
  source = "../.."
  tailscale_auth_key = var.auth_key
  eks_cluster_id = module.eks.cluster_id 
  region = var.region 
}
