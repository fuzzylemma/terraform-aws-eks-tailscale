# terraform aws eks tailscale


## usage
```
module "tailscale" {
    source = "fuzzylemma/eks-tailscale/aws" 
    version = "0.1.0"
    auth_key = "<authentication from tailscale>"
    eks_cluster_id = "<aws eks cluster id>"
}
```
> Note: this deployment does not configure security groups. The deployment should be able to reach tailscale DERP servers over port `443`. Ingress and egress rules are needed for this.

 

## references
- [tailscale x k8s article](https://tailscale.com/kb/1185/kubernetes)
- [tailscale's k8s documentation](https://github.com/tailscale/tailscale/tree/main/docs/k8s)
- [tailscale's docker image](https://registry.hub.docker.com/r/tailscale/tailscale)
