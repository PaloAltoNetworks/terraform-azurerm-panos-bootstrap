# Module Example

The terraform-azurerm-panos-bootstrap module is used to create an Azure file share that to be used for bootstrapping Palo Alto Networks VM-Series virtual firewall instances.  This bootstrap package will include an `init-cfg.txt` file that provides the basic configuration details to configure the VM-Series instance and register it with its Panorama management console.  It may optionally include a PAN-OS software image, application and threat signature updates, VM-Series plug-ins, and/or license files.

```
files
├── config
│   └── init-cfg.txt
├── content
├── license
├── plugins
└── software
```

## Examples

```terraform
#
# main.tf
#

provider "azurerm" {
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
}

module "bootstrap" {
  source = "github.com/stealthllama/terraform-azurerm-panos-bootstrap"


  azure_resource_group = var.azure_resource_group
  azure_location       = var.azure_location

  hostname         = "az-firewall"
  panorama-server  = "panorama1.example.org"
  panorama-server2 = "panorama2.example.org
  tplname          = "Azure Firewall Template"
  dgname           = "Azure Firewalls"
  vm-auth-key      = "supersecretauthkey"
}
```

## Usage
1. Define a `main.tf` file that calls the module and provides any required and optional variables.
2. Define a `variables.tf` file that declares the variables that will be utilized.
3. Define an `output.tf` to capture and display the module return values (optional).
4. Define a `terraform.tfvars` file containing the required variables and associated values.
5. Initialize the providers and modules with the `terraform init` command.
6. Validate the plan using the `terraform plan` command.
7. Apply the plan using the `terraform apply` command. 

## References
* [VM-Series Firewall Bootstrap Workflow](https://docs.paloaltonetworks.com/vm-series/9-1/vm-series-deployment/bootstrap-the-vm-series-firewall/vm-series-firewall-bootstrap-workflow.html#id59fe5979-c29d-42aa-8e72-14a2c12855f6)
* [Bootstrap the VM-Series Firewall on Azure](https://docs.paloaltonetworks.com/vm-series/9-1/vm-series-deployment/bootstrap-the-vm-series-firewall/bootstrap-the-vm-series-firewall-in-azure.html#idd51f75b8-e579-44d6-a809-2fafcfe4b3b6)
* [Prepare the Bootstrap Package](https://docs.paloaltonetworks.com/vm-series/9-1/vm-series-deployment/bootstrap-the-vm-series-firewall/prepare-the-bootstrap-package.html#id5575318c-1de8-497a-960a-1d7417feefa6)