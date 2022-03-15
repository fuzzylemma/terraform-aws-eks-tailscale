resource "kubernetes_secret" "tailscale_auth" {
  metadata {
    name = "tailscale-auth"
  }
  data = {
    AUTH_KEY = "tskey-kedpn36CNTRL-LrKiCaXFr1Q34mAGwhUHXc"
  }
}

resource "kubernetes_service_account" "tailscale_sa" {
  metadata {
    name = "tailscale"
  }
}

resource "kubernetes_role_binding" "tailscale_rbac" {
  metadata {
    name = "tailscale"
  }
  subject {
    kind = "ServiceAccount"
    name = "tailscale"
  }
  role_ref {
    kind = "Role"
    name = "tailscale"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_role" "tailscale_role" {
  metadata {
    name = "tailscale"
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["create"]
  }
  rule {
    api_groups = [""]
    resource_names = ["tailscale-auth"]
    resources = ["secrets"]
    verbs = ["get", "update"]
  }
}
