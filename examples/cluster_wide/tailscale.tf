module "tailscale_subnet_router" {
  source = "../../tailscale-subnet-router"
  auth_key = var.auth_key
}
