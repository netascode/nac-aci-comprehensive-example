terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
    }
  }
}

provider "aci" {
  username = "admin"
  password = "Ananda@0452200490"
  url      = "https://APICNginx"
  insecure = false
}

module "aci" {
  source  = "netascode/nac-aci/aci"
  version = "1.2.0"

  yaml_directories = ["data"]

  manage_access_policies    = false
  manage_fabric_policies    = false
  manage_pod_policies       = false
  manage_node_policies      = false
  manage_interface_policies = false
  manage_tenants            = true
}
