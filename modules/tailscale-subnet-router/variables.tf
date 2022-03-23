variable "deployment_name" {
  description = "AWS EKS Deployments name"
  default = "tailscale"
  type = string
}
variable "app_name" {
  description = "AWS EKS app label name"
  default = "tailscale"
  type = string
}
variable "pod_name" {
  description = "AWS EKS pod name"
  default = "tailscale"
  type = string
}
variable "container_name" {
  description = "AWS EKS pod container name"
  default = "tailscale"
  type = string
}
variable "namespace" {
  description = "AWS EKS namespace for tailscale kubernetes components"
  default = "tailscale"
  type = string
}
variable "service_account" {
  description = "AWS EKS kubernetes service account for tailscale"
  default = "tailscale"
  type = string
}
variable "clusterrole" {
  description = "AWS EKS kubernetes service account for tailscale cluster role"
  default = "tailscale"
  type = string
}
variable "rbac_name" {
  description = "AWS EKS kubernetes rbac name"
  default = "tailscale"
  type = string
}
variable "auth_state_secret" {
  description = "AWS EKS name of secret for the tailscale daemon to keep its state in"
  default = "tailscale-auth-state"
  type = string
}
variable "auth_key_secret" {
  description = "AWS EKS secret name to store tailscale authentication key"
  default = "tailscale-auth-key"
  type = string
}
variable "tailscale_auth_key" {
  description = "Tailscale authentication key"
  type = string 
}
variable "routes" {
  description = "CIDR blocks to be advertised by the tailscale subnet router"
  default = ["172.20.0.0/16", "10.0.0.0/16"]
  type = list(string)
}
