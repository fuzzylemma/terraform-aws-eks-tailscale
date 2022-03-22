variable "deployment_name" {
  default = "tailscale-deploy"
  type = string
}
variable "app_name" {
  default = "tailscale-app"
  type = string
}
variable "pod_name" {
  default = "tailscale-pod"
  type = string
}
variable "container_name" {
  default = "tailscale-cont"
  type = string
}
variable "namespace" {
  default = "tailscale"
  type = string
}
variable "service_account" {
  default = "tailer"
  type = string
}
variable "clusterrole" {
  default = "scaler"
  type = string
}
variable "auth_state_secret" {
  default = "tailscale-auth-state"
  type = string
}
variable "rbac_name" {
  default = "tailscale-rbac"
  type = string
}
variable "auth_key_secret" {
  default = "tailscale-auth-key"
  type = string
}
variable "auth_key" {
  type = string 
}
variable "routes" {
  default = ["172.20.0.0/16", "10.0.0.0/16"]
  type = list(string)
}
