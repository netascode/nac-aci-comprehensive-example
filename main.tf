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
  url      = "https://192.168.1.71"
  insecure = false
}

module "aci" {
  source  = "netascode/nac-aci/aci"
  version = "1.2.0"

  yaml_directories = ["data"]

  manage_access_policies    = true
  manage_fabric_policies    = true
  manage_pod_policies       = true
  manage_node_policies      = true
  manage_interface_policies = true
  manage_tenants            = true
}
