module "subnet_router" {
  source   = "./modules/tailscale-subnet-router"
  tailscale_auth_key = var.tailscale_auth_key
}
