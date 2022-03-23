resource "kubernetes_secret" "tailscale_auth" {
  metadata {
    name = var.auth_key_secret 
    namespace = var.namespace
  }
  data = {
    AUTH_KEY = var.tailscale_auth_key 
  }
}
