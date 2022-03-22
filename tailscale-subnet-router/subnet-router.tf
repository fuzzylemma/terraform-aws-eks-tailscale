locals {
  auth_key_key = "AUTH_KEY"
  image_name = "fuzzylemma/tailscale-subnet-router"
  image_tag = "test"
}

resource "kubernetes_deployment" "subnet_router" {
  metadata {
    name = var.deployment_name 
    namespace = var.namespace 
    labels = {
      app = var.app_name 
    }
  }

  spec {

    min_ready_seconds = 30
    replicas = 1 

    selector {
      match_labels = {
        app = var.app_name 
      }
    }

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        name = var.pod_name
        labels = {
          app = var.app_name 
        }
      }
      spec {
        service_account_name = var.service_account 
        host_network = false

        // get around pod security policy
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
          name = var.container_name 
          image = "${local.image_name}:${local.image_tag}"
          image_pull_policy = "Always"

          env {
            name = "KUBE_SECRET"
            value = var.auth_state_secret 
          }
          env {
            name = "USERSPACE"
            value = "true" 
          }
          env {
            name = "ROUTES"
            value = join(",", var.routes)
          }
          env {
            name = "AUTH_KEY"
            value_from {
              secret_key_ref {
                name = var.auth_key_secret 
                key = local.auth_key_key  
              }
            }
          }
          security_context {
            capabilities {
              add = ["NET_ADMIN", "SYS_MODULE"]
            }
          }

          /*
          liveness_probe {
            initial_delay_seconds = 120 
            failure_threshold = 3
            period_seconds = 10
            success_threshold = 1
            exec {
              command = ["tailscale", "status"]
            }
          }
          */

        } // container
      } // ispec
    } // template
  } // ospec
}
