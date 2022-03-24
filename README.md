<a href="https://terraform.io">
    <img src=".github/terraform_logo.svg" alt="Terraform logo" title="Terraform" align="right" height="50" />
</a>

# terraform aws eks tailscale

Terraform module to make AWS EKS cluster accesible through [tailscale](https://tailscale.com).

## usage
```
## Config kuberenetes cluster
data "aws_eks_cluster" "this" {
  name = var.eks_cluster_id
}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_id
}

provider "kubernetes" {
  host = data.aws_eks_cluster.this.endpoint
  token = data.aws_eks_cluster_auth.this.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
}

## Deploy tailscale to cluster
module "tailscale" {
    source = "fuzzylemma/eks-tailscale/aws" 
    version = "0.1.0"
    auth_key = "<authentication from tailscale>"
    eks_cluster_id = "<aws eks cluster id>"
}
```

> Note: this deployment does not configure security groups. The deployment should be able to reach tailscale DERP servers over port `443`. Ingress and egress rules are needed for this.

> Note: after deployment, the routes need to be manually approved in tailscale UI before they are accessible.
 

## references
- [tailscale x k8s article](https://tailscale.com/kb/1185/kubernetes)
- [tailscale's k8s documentation](https://github.com/tailscale/tailscale/tree/main/docs/k8s)
- [tailscale's docker image](https://registry.hub.docker.com/r/tailscale/tailscale)
