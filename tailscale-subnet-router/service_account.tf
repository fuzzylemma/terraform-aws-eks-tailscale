resource "kubernetes_service_account" "tailscale_sa" {
  metadata {
    name = var.service_account 
    namespace = var.namespace
  }
}
