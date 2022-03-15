resource "kubernetes_deployment_v1" "nginx" {
  metadata {
    name = "nginx"
    labels = {
      App = "nginx"
    }
  }
  spec {
    replicas = 1 
    selector {
      match_labels = {
        App = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          App = "nginx"
        }
      }
      spec {
        container {
          image = "nginx"
          name = "nginx"
          resources {
            limits = {
              cpu = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu = "250m"
              memory = "50Mi"
            }
          }
        } // container
      } // ispec
    } // template
  } // ospec
}

resource "kubernetes_service_v1" "nginx_cluster_ip" {
  metadata {
    name = "nginx-svc"
  }
  spec {
    port = 80 
  }
  type = "ClusterIP"
}

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
    name = "tailscale" # link
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
    resource_names = ["tailscale-auth"]  # link
    resources = ["secrets"]
    verbs = ["get", "update"]
  }
}

resource "kubernetes_deployment_v1" "tailscale" {
  depends_on = [kubernetes_service_v1.nginx_cluster_ip.id]
  metadata {
    name = "tailscale-proxy"
    labels = {
      App = "tailscale-proxy"
    }
  }
  spec {
    replicas = 1 
    selector {
      match_labels = {
        App = "tailscale-proxy"
      }
    }
    template {
      metadata {
        labels = {
          App = "tailscale-proxy"
        }
      }
      spec {
        service_account_name = "tailscale"

        init_container {
          name = "sysctler"
          image = "busybox"
          security_context {
            privileged = true
          }
          command = ["/bin/sh"]
          args = ["-c", "sysctl -w net.ipv4.ip_forward=1 ; sysctl -w net.ipv6.conf.all.forwarding=1"]
        }
        container {
          image = "fuzzylemma/tailscale:latest"
          image_pull_policy = "Always"
          name = "tailscale-proxy"
          env {
            name = "KUBE_SECRET"
            value = "tailscale-auth"
          }
          env {
            name = "USERSPACE"
            value = "false" 
          }
          env {
            name = "AUTH_KEY"
            value = "tskey-kedpn36CNTRL-LrKiCaXFr1Q34mAGwhUHXc"
          }
          env {
            name = "DEST_IP"
            value = "" 
          }
          security_context {
            capabilities {
              add = ["NET_ADMIN", "SYS_MODULE"]
            }
          }
        } // container
      } // ispec
    } // template
  } // ospec
}
