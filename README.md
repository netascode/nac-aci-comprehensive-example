[![Terraform Version](https://img.shields.io/badge/terraform-%5E1.8-blue)](https://www.terraform.io)

# Network-as-Code - Comprehensive example for ACI

This example is part of the Cisco [*Network as Code*](https://netascode.cisco.com) project. Its goal is to allow users to instantiate network fabrics in minutes using an easy to use, opinionated data model. It takes away the complexity of having to deal with references, dependencies or loops. By completely separating data (defining variables) from logic (infrastructure declaration), it allows the user to focus on describing the intended configuration while using a set of maintained and tested Terraform Modules without the need to understand the low-level ACI object model.

More information can be found here: [https://netascode.cisco.com/solutions/aci/comprehensive_example](https://netascode.cisco.com/solutions/aci/comprehensive_example).

## Leaf Interface Configuration Options

This example includes multiple methods to configure the interfaces on the ACI leaf switches.

### Option 01

The "new" API-friendly method of configuring interfaces results in fewer API calls to APIC. When using this method APIC creates system-generated Leaf Switch Profiles which are mapped 1:1 to (system generated) Leaf Interface Profiles with Access Port Selectors names matching the Interface Policy Group name.

Files can be found in (`data/option-01`)

### Option 02

This option produces the same structure as Option 01 where each Leaf Switch Profile maps (1:1) to a unique Leaf Interface Profile, however it provides more flexibility by avoiding system-generated names.

Files can be found in (`data/option-02`)

### Option 03

This option configures each interface on each switch individually. It is less API-friendly than Option 01 or Option 02 as it create more API calls. Whilst a valid configuration method, this option should ideally be avoided due to the additional API impact on large scale networks.

Files can be found in (`data/option-03`)

---

## Resource Impact Analysis

The following table details the number of resources created when applying the different interface configuration methods found in this example i.e. the configuration files in:

- data/02_access-policies/interfaceconfiguration-option-01
- data/02_access-policies/interfaceconfiguration-option-02
- data/02_access-policies/interfaceconfiguration-option-03

| Option  | Base Resources | Scaling Impact                                      |
|--------|----------------|----------------------------------------------------|
| Option-01 | 22             | +1 resource per additional interface               |
| Option-02 | 48             | +1 per existing selector / +3 per new selector     |
| Option-03 | 96             | +3 resources per additional interface              |

<br>

Whilst the number of Base Resources are important, the impact can be more readily noticed when configuring multiple ports for the same use case. 

For example if a deployment consisted of 2x leaf switches with 10x dual homed hosts this would result in the following number of resources being added:

| Option  | Base Resources | Scaling Impact                                      |
|--------|----------------|----------------------------------------------------|
| Option-01 | 24             | +1 resource per additional interface               |
| Option-02 | 34             | +1 per existing selector / +3 per new selector     |
| Option-03 | 108            | +3 resources per additional interface              |

The number of resources being added has a direct impact on the time it takes to complete a given plan. 

---

## Deployment Steps

1. Select required interface configuration method in the `yaml_directories` code block (uncomment preferred block) in `main.tf`

```hcl
  yaml_directories = [
    "data/01_fabric-setup", 
    "data/02_access-policies",
    "data/02_access-policies/interface-configuration-option-01",
    # "data/02_access-policies/interface-configuration-option-02",     
    # "data/02_access-policies/interface-configuration-option-03",     
    "data/03_virtual-networking"
  ]
```

2. Select tenant plan(s) in `yaml_files` (comment/uncomment specific files)  

```hcl
  yaml_files = [
    "data/04_tenants/mgmt/configuration-v1.nac.yaml",
  
    # "data/04_tenants/production/configuration-v1.nac.yaml",
    # "data/04_tenants/production/configuration-v2.nac.yaml",
    # "data/04_tenants/production/configuration-v3.nac.yaml", 
    "data/04_tenants/production/configuration-v4.nac.yaml"
```

3. Save main.tf and run:
   ```bash
    terraform plan
    terraform apply
    ```
