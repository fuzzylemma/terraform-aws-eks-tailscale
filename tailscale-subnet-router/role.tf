resource "kubernetes_role_binding" "tailscale_rbac" {
  metadata {
    name = var.rbac_name 
    namespace = var.namespace 
  }
  subject {
    kind = "ServiceAccount"
    name = var.service_account 
    namespace = var.namespace
  }
  role_ref {
    kind = "Role"
    name = var.service_account 
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_role" "tailscale_role" {
  metadata {
    name = var.service_account 
    namespace = var.namespace 
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["create"]
  }
  rule {
    api_groups = [""]
    resource_names = [var.auth_state_secret]
    resources = ["secrets"]
    verbs = ["get", "update"]
  }
}
