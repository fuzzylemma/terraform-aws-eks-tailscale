resource "kubernetes_deployment" "tailscale-sub" {
  metadata {
    name = "tailscale"
    labels = {
      App = "tailscale"
    }
  }
  spec {
    replicas = 1 
    selector {
      match_labels = {
        App = "tailscale"
      }
    }
    template {
      metadata {
        labels = {
          App = "tailscale"
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
          name = "subnet-route"
          env {
            name = "KUBE_SECRET"
            value = "tailscale-auth"
          }
          env {
            name = "USERSPACE"
            value = "false" 
          }
          /*
          env_from {
            prefix = "AUTH_KEY" # kubernetes_secret.tailscale_auth.data.keys[0] ? 
            secret_ref {
              //name = kubernetes_secret.tailscale_auth.name
              optional = true
            }
          }
          */
          env {
            name = "ROUTES"
            value = "172.20.0.0/16,10.0.3.0/24,10.0.2.0/24,10.0.1.0/24"
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
