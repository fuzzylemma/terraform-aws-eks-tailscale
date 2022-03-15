resource "kubernetes_deployment" "tailscale-proxy" {
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
          name = "prox"
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
            value = "172.20.88.232" 
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
