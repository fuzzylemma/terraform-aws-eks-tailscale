resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "scalable-nginx-example"
    labels = {
      App = "ScalableNginxExample"
    }
  }
  spec {
    replicas = 1 
    selector {
      match_labels = {
        App = "ScalableNginxExample"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalableNginxExample"
        }
      }
      spec {
        service_account_name = "tailscale"
        container {
          image = "fuzzylemma/tailscale:latest"
          name = "tailscale"
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

          security_context {
            capabilities {
              add = ["NET_ADMIN"]
            }
          }
        } // container

        container {
          image = "nginx:1.7.8"
          name = "example"
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
