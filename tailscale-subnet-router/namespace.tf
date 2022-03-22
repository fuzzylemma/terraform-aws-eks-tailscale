resource "kubernetes_namespace" "tailscale" {
  metadata {
    name = var.namespace 
  }
}
