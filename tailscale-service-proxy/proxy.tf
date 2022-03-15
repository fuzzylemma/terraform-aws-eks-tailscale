resource "kubernetes_deployment_v1" "tailscale" {
  //depends_on = [kubernetes_service_v1.nginx_cluster_ip.id]
  metadata {
    name = var.name 
    labels = {
      App = var.app 
    }
  }
  spec {
    replicas = var.replicas 
    selector {
      match_labels = {
        App = var.app 
      }
    }
    template {
      metadata {
        labels = {
          App = var.app 
        }
      }
      spec {
        service_account_name = var.service_account_name 

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
          name = "${var.name}-cont" 
          env {
            name = "KUBE_SECRET"
            value = "${var.state_secret_name}"
          }
          env {
            name = "USERSPACE"
            value = "${var.userspace}" 
          }
          env {
            name = "AUTH_KEY"
            value = "${var.tailscale_auth_key}" // envFrom
          }
          env {
            name = "DEST_IP"
            value = "${var.service_cluster_ip}" 
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
