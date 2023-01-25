terraform {
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = ">= 2.6.0"
    }
  }
}

provider "aci" {
  username = "username"
  password = "password"
  url      = "https://apic.url"
}

module "merge" {
  source  = "netascode/nac-merge/utils"
  version = "0.1.2"

  yaml_strings = concat(
    [for file in fileset(path.module, "data/*.yaml") : file(file)],
    [file("${path.module}/defaults/defaults.yaml")],
  )
}

module "access_policies" {
  source  = "netascode/nac-access-policies/aci"
  version = "0.4.0"

  model = module.merge.model
}

module "fabric_policies" {
  source  = "netascode/nac-fabric-policies/aci"
  version = "0.4.1"

  model = module.merge.model
}

module "pod_policies" {
  source  = "netascode/nac-pod-policies/aci"
  version = "0.4.0"

  model = module.merge.model
}

module "node_policies" {
  source  = "netascode/nac-node-policies/aci"
  version = "0.4.0"

  model = module.merge.model

  dependencies = [module.access_policies.critical_resources_done]
}

module "interface_policies" {
  source  = "netascode/nac-interface-policies/aci"
  version = "0.4.0"

  for_each = { for node in try(module.merge.model.apic.interface_policies.nodes, []) : node.id => node }
  model    = module.merge.model
  node_id  = each.value.id

  dependencies = [module.access_policies.critical_resources_done]
}

module "tenant" {
  source  = "netascode/nac-tenant/aci"
  version = "0.4.1"

  for_each    = { for tenant in try(module.merge.model.apic.tenants, []) : tenant.name => tenant }
  model       = module.merge.model
  tenant_name = each.value.name
}
