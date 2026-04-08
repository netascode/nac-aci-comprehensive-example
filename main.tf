terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
    }
  }
}

provider "aci" {
  username = "admin"
  password = "C1sco12345"
  url      = "https://198.18.133.200/"
}

module "aci" {
  source  = "netascode/nac-aci/aci"
  version = "1.2.0"

  manage_access_policies    = true
  manage_fabric_policies    = true
  manage_pod_policies       = true
  manage_node_policies      = true
  manage_interface_policies = true
  manage_tenants            = true

  # ---------------------------------------------------------------------------
  # LEAF INTERFACE CONFIGURATION OPTIONS
  # ---------------------------------------------------------------------------
  # Option 01 (data/option-01): 
  #   The "new" API-friendly method. Results in fewer API calls.
  #   Creates system-generated Leaf Switch Profiles mapped 1:1 to Leaf Interface 
  #   Profiles with Access Port Selectors based on Interface Policy Groups.
  #
  # Option 02 (data/option-02): 
  #   Same structure as Option 01 but provides more flexibility by avoiding 
  #   system-generated profiles.
  #
  # Option 03 (data/option-03): 
  #   Configures interfaces individually. Less API friendly (more API calls).
  # ---------------------------------------------------------------------------

  # ---------------------------------------------------------------------------
  # RESOURCE IMPACT ANALYSIS
  # ---------------------------------------------------------------------------
  # Option  | Base Resources | Scaling Impact
  # --------|----------------|-------------------------------------------------
  # Opt-01  | 22             | +1 resource per additional interface
  # Opt-02  | 48             | +1 per existing selector / +3 per new selector
  # Opt-03  | 96             | +3 resources per additional interface
  # ---------------------------------------------------------------------------

  # ---------------------------------------------------------------------------
  # DEPLOYMENT STEPS
  # ---------------------------------------------------------------------------
  # 1) Select interface method in "yaml_directories" (uncomment preferred block)
  # 2) Select tenant plans in "yaml_files" (comment/uncomment specific files)
  # 3) Save file and run: terraform plan
  # 4) Review and run:    terraform apply
  # ---------------------------------------------------------------------------

  yaml_directories = [
    "data/01_fabric-setup", 
    "data/02_access-policies",
    # "data/02_access-policies/interface-configuration-option-01",
    "data/02_access-policies/interface-configuration-option-02",     
    # "data/02_access-policies/interface-configuration-option-03",     
    "data/03_virtual-networking"
  ]

  yaml_files = [
    "data/04_tenants/mgmt/configuration-v1.nac.yaml",
  
    # "data/04_tenants/production/configuration-v1.nac.yaml",
    # "data/04_tenants/production/configuration-v2.nac.yaml",
    # "data/04_tenants/production/configuration-v3.nac.yaml", 
    "data/04_tenants/production/configuration-v4.nac.yaml"
  ]

}