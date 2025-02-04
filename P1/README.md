# Azure: Deploying a scalable IaaS web server in Azure

## Introduction
Your company's development team has built an application that needs to be deployed on Azure. While the application itself is self-contained, the infrastructure must be customizable based on build-time specifications and scalable to support a CI/CD pipeline.

The application must run on Infrastructure as a Service (IaaS) instead of Azure App Service to reduce costs.
Since this is expected to be a high-traffic service, it should be deployed across multiple virtual machines (VMs) for scalability.
A load balancer should be used to distribute incoming traffic efficiently.
The infrastructure must follow security best practices to ensure a secure deployment.

### Technology Stack
To meet these requirements, we will use:
- ✅ Packer → To create a custom server image for consistent VM deployments.
- ✅ Terraform → To define an automated, scalable, and repeatable infrastructure deployment.
- ✅ Azure Load Balancer → To manage and distribute incoming traffic across multiple VMs.
- ✅ Azure Policy → To enforce governance and security standards.

This approach will allow the infrastructure to be easily managed, cost-effective, and ready for future scalability as the application grows. 🚀


## Dependencies
To complete this project, you will need:

- An Azure account
- Packer installed
- Terraform installed

## Instructions

### App Registration (Optional)

You can use your personal Azure account as well to complete this exercise. Everything would remain the same, only difference would be in getting the values of clientID, clientSecret and SubscriptionID. For that, you need to do an app registration in Azure Active Directory (Microsoft Entra ID). After that, you need to create a client Secret in that application, and you are good to go to use those values.

![image](https://github.com/user-attachments/assets/c4a0119f-fd22-4dd0-a1c0-efd32c41316b)

(You can do also by Azure CLI- Important is **assigning Contributor Role**)

### Setting Up Azure Environment Variables

Before running the Packer build or any Azure-related tasks, make sure to set the following environment variables.

In your terminal, run:

```bash
export ARM_CLIENT_ID='XXXXXX-2d52-XXXX-84c2-XXXXXXXXXX'
export ARM_CLIENT_SECRET='XXXXXXX-XXXX-4bc3-bc15-6dbdb78XXXXX'
export ARM_SUBSCRIPTION_ID='XXXXXXX-XXXX-4f7c-XXX-XXXXXXXXX'
```

### Create Server Image: Packer Template

First, use Packer to create a server image, ensuring the provided application is included in the template. 

Define the necessary variables and configure the provisioning steps to install the application within the image. 
Be sure to set up any required configuration files, environment variables, and dependencies during the provisioning process.

Once the template is ready, run Packer to build the image. Validate the image to ensure everything is correctly configured. After that, use the newly created image to deploy servers with the application pre-installed, ensuring consistency across environments.

![image](https://github.com/user-attachments/assets/78461956-e237-4b4e-a745-5eada937310f)





- check with **ls command** that it has been uploaded
- run: **packer build server.json**

  
if the image already exists, overwrite the existing image
- **packer build -force server.json**



**After successful build, check the image:**
![image](https://github.com/user-attachments/assets/ae19cbf6-1318-4387-8247-a0b0825b50bb)



### Terraform 

The terraform file creates these resources listed below:

- **Resource Group** - A container to manage all related Azure resources.  
- **Virtual Network** - Defines the private network space for resources.  
  - **Subnet** - Segments the Virtual Network for better organization.  
  - **Network Security Group (NSG)** - Restricts inbound/outbound traffic for security.  
- **Network Interfaces (NICs)** - Connects VMs to the network.  
- **Public IP** - Provides external access to the load balancer or VMs.  
- **Load Balancer** - Distributes traffic across multiple VMs for high availability.  
- **Availability Set** - Ensures VM redundancy by spreading them across fault & update domains.  
- **Linux Virtual Machines (3 default)** - Compute instances running Linux.  
- **Managed Disks (1 per VM)** - Persistent storage for each VM.  



#### Terraform Deployment Guide

To deploy and manage resources using Terraform, follow these steps:

- First, initialize your Terraform environment by running `terraform init`. This prepares your working directory for Terraform operations.

- Next, you may need to modify the `vars.tf` file to set your preferences. This file contains variables such as the resource group name, a prefix for most resources, the number of VMs (default is 3), and the location (default is West Europe). If you are using a different resource group for your Packer image, you’ll need to update the `packer_resource_group` variable to match the correct name.

- Once the variables are updated, review the `main.tf` file to confirm that it will create the correct resources for your needs.

- Before applying any changes, run `terraform plan -out solution.plan`. This will show you a preview of the changes Terraform will make. Review this carefully to ensure it aligns with your expectations.

- If the plan looks good, proceed by running `terraform apply solution.plan`. This will apply the changes and provision the resources as per your plan.

- Finally, if you no longer need the resources, you can clean up by running `terraform destroy`. This command will remove all the resources that were created by the script.

**Important Notes:**
- Ensure that your Terraform environment is set up correctly before you start.
- Always review the output of `terraform plan` to verify the changes.
- Use `terraform destroy` to remove resources when they are no longer needed to avoid unnecessary costs.



### Output

```bash
C:\Users\shekh\Downloads\azure-devops\p1\tf>terraform plan -out solution.plan
data.azurerm_image.web: Reading...
azurerm_resource_group.main: Refreshing state... [id=/subscriptions/0fc88ba0-a7fc-4f7c-bd55-59425648f69b/resourceGroups/sb-west-europe]
data.azurerm_image.web: Read complete after 0s [id=/subscriptions/0fc88ba0-a7fc-4f7c-bd55-59425648f69b/resourceGroups/sb-west-europe/providers/Microsoft.Compute/images/myPackerImage]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_availability_set.main will be created
  + resource "azurerm_availability_set" "main" {
      + id                           = (known after apply)
      + location                     = "westeurope"
      + managed                      = true
      + name                         = "sb--aset"
      + platform_fault_domain_count  = 2
      + platform_update_domain_count = 5
      + resource_group_name          = "sb-west-europe"
      + tags                         = {
          + "Environment " = "Development"
        }
    }

  # azurerm_lb.main will be created
  + resource "azurerm_lb" "main" {
      + id                   = (known after apply)
      + location             = "westeurope"
      + name                 = "sb--lb"
      + private_ip_address   = (known after apply)
      + private_ip_addresses = (known after apply)
      + resource_group_name  = "sb-west-europe"
      + sku                  = "Standard"
      + sku_tier             = "Regional"
      + tags                 = {
          + "Environment " = "Development"
        }

      + frontend_ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + id                                                 = (known after apply)
          + inbound_nat_rules                                  = (known after apply)
          + load_balancer_rules                                = (known after apply)
          + name                                               = "PublicIPAddress"
          + outbound_rules                                     = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = (known after apply)
          + private_ip_address_version                         = (known after apply)
          + public_ip_address_id                               = (known after apply)
          + public_ip_prefix_id                                = (known after apply)
          + subnet_id                                          = (known after apply)
        }
    }

  # azurerm_lb_backend_address_pool.main will be created
  + resource "azurerm_lb_backend_address_pool" "main" {
      + backend_ip_configurations = (known after apply)
      + id                        = (known after apply)
      + inbound_nat_rules         = (known after apply)
      + load_balancing_rules      = (known after apply)
      + loadbalancer_id           = (known after apply)
      + name                      = "sb--lb-backend-pool"
      + outbound_rules            = (known after apply)
    }

  # azurerm_lb_probe.main will be created
  + resource "azurerm_lb_probe" "main" {
      + id                  = (known after apply)
      + interval_in_seconds = 15
      + load_balancer_rules = (known after apply)
      + loadbalancer_id     = (known after apply)
      + name                = "http-server-probe"
      + number_of_probes    = 2
      + port                = 8080
      + probe_threshold     = 1
      + protocol            = "Tcp"
    }

  # azurerm_lb_rule.main will be created
  + resource "azurerm_lb_rule" "main" {
      + backend_port                   = 8080
      + disable_outbound_snat          = false
      + enable_floating_ip             = false
      + frontend_ip_configuration_id   = (known after apply)
      + frontend_ip_configuration_name = "PublicIPAddress"
      + frontend_port                  = 80
      + id                             = (known after apply)
      + idle_timeout_in_minutes        = 4
      + load_distribution              = "Default"
      + loadbalancer_id                = (known after apply)
      + name                           = "HTTP"
      + probe_id                       = (known after apply)
      + protocol                       = "Tcp"
    }

  # azurerm_linux_virtual_machine.main[0] will be created
  + resource "azurerm_linux_virtual_machine" "main" {
      + admin_password                                         = (sensitive value)
      + admin_username                                         = "sbiswas"
      + allow_extension_operations                             = true
      + availability_set_id                                    = (known after apply)
      + bypass_platform_safety_checks_on_user_schedule_enabled = false
      + computer_name                                          = (known after apply)
      + disable_password_authentication                        = false
      + disk_controller_type                                   = (known after apply)
      + extensions_time_budget                                 = "PT1H30M"
      + id                                                     = (known after apply)
      + location                                               = "westeurope"
      + max_bid_price                                          = -1
      + name                                                   = "sb--0-vm"
      + network_interface_ids                                  = (known after apply)
      + patch_assessment_mode                                  = "ImageDefault"
      + patch_mode                                             = "ImageDefault"
      + platform_fault_domain                                  = -1
      + priority                                               = "Regular"
      + private_ip_address                                     = (known after apply)
      + private_ip_addresses                                   = (known after apply)
      + provision_vm_agent                                     = true
      + public_ip_address                                      = (known after apply)
      + public_ip_addresses                                    = (known after apply)
      + resource_group_name                                    = "sb-west-europe"
      + size                                                   = "Standard_B1ls"
      + source_image_id                                        = "/subscriptions/0fc88ba0-a7fc-4f7c-bd55-59425648f69b/resourceGroups/sb-west-europe/providers/Microsoft.Compute/images/myPackerImage"
      + tags                                                   = {
          + "Environment " = "Development"
          + "project-name" = "Deploying a Web Server in Azure"
        }
      + virtual_machine_id                                     = (known after apply)
      + vm_agent_platform_updates_enabled                      = false

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + id                        = (known after apply)
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + termination_notification (known after apply)
    }

  # azurerm_linux_virtual_machine.main[1] will be created
  + resource "azurerm_linux_virtual_machine" "main" {
      + admin_password                                         = (sensitive value)
      + admin_username                                         = "sbiswas"
      + allow_extension_operations                             = true
      + availability_set_id                                    = (known after apply)
      + bypass_platform_safety_checks_on_user_schedule_enabled = false
      + computer_name                                          = (known after apply)
      + disable_password_authentication                        = false
      + disk_controller_type                                   = (known after apply)
      + extensions_time_budget                                 = "PT1H30M"
      + id                                                     = (known after apply)
      + location                                               = "westeurope"
      + max_bid_price                                          = -1
      + name                                                   = "sb--1-vm"
      + network_interface_ids                                  = (known after apply)
      + patch_assessment_mode                                  = "ImageDefault"
      + patch_mode                                             = "ImageDefault"
      + platform_fault_domain                                  = -1
      + priority                                               = "Regular"
      + private_ip_address                                     = (known after apply)
      + private_ip_addresses                                   = (known after apply)
      + provision_vm_agent                                     = true
      + public_ip_address                                      = (known after apply)
      + public_ip_addresses                                    = (known after apply)
      + resource_group_name                                    = "sb-west-europe"
      + size                                                   = "Standard_B1ls"
      + source_image_id                                        = "/subscriptions/0fc88ba0-a7fc-4f7c-bd55-59425648f69b/resourceGroups/sb-west-europe/providers/Microsoft.Compute/images/myPackerImage"
      + tags                                                   = {
          + "Environment " = "Development"
          + "project-name" = "Deploying a Web Server in Azure"
        }
      + virtual_machine_id                                     = (known after apply)
      + vm_agent_platform_updates_enabled                      = false

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + id                        = (known after apply)
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + termination_notification (known after apply)
    }

  # azurerm_linux_virtual_machine.main[2] will be created
  + resource "azurerm_linux_virtual_machine" "main" {
      + admin_password                                         = (sensitive value)
      + admin_username                                         = "sbiswas"
      + allow_extension_operations                             = true
      + availability_set_id                                    = (known after apply)
      + bypass_platform_safety_checks_on_user_schedule_enabled = false
      + computer_name                                          = (known after apply)
      + disable_password_authentication                        = false
      + disk_controller_type                                   = (known after apply)
      + extensions_time_budget                                 = "PT1H30M"
      + id                                                     = (known after apply)
      + location                                               = "westeurope"
      + max_bid_price                                          = -1
      + name                                                   = "sb--2-vm"
      + network_interface_ids                                  = (known after apply)
      + patch_assessment_mode                                  = "ImageDefault"
      + patch_mode                                             = "ImageDefault"
      + platform_fault_domain                                  = -1
      + priority                                               = "Regular"
      + private_ip_address                                     = (known after apply)
      + private_ip_addresses                                   = (known after apply)
      + provision_vm_agent                                     = true
      + public_ip_address                                      = (known after apply)
      + public_ip_addresses                                    = (known after apply)
      + resource_group_name                                    = "sb-west-europe"
      + size                                                   = "Standard_B1ls"
      + source_image_id                                        = "/subscriptions/0fc88ba0-a7fc-4f7c-bd55-59425648f69b/resourceGroups/sb-west-europe/providers/Microsoft.Compute/images/myPackerImage"
      + tags                                                   = {
          + "Environment " = "Development"
          + "project-name" = "Deploying a Web Server in Azure"
        }
      + virtual_machine_id                                     = (known after apply)
      + vm_agent_platform_updates_enabled                      = false

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + id                        = (known after apply)
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + termination_notification (known after apply)
    }

  # azurerm_managed_disk.main[0] will be created
  + resource "azurerm_managed_disk" "main" {
      + create_option                     = "Empty"
      + disk_iops_read_only               = (known after apply)
      + disk_iops_read_write              = (known after apply)
      + disk_mbps_read_only               = (known after apply)
      + disk_mbps_read_write              = (known after apply)
      + disk_size_gb                      = 1
      + id                                = (known after apply)
      + location                          = "westeurope"
      + logical_sector_size               = (known after apply)
      + max_shares                        = (known after apply)
      + name                              = "data-disk-0"
      + optimized_frequent_attach_enabled = false
      + performance_plus_enabled          = false
      + public_network_access_enabled     = true
      + resource_group_name               = "sb-west-europe"
      + source_uri                        = (known after apply)
      + storage_account_type              = "Standard_LRS"
      + tags                              = {
          + "Environment " = "Development"
        }
      + tier                              = (known after apply)
    }

  # azurerm_managed_disk.main[1] will be created
  + resource "azurerm_managed_disk" "main" {
      + create_option                     = "Empty"
      + disk_iops_read_only               = (known after apply)
      + disk_iops_read_write              = (known after apply)
      + disk_mbps_read_only               = (known after apply)
      + disk_mbps_read_write              = (known after apply)
      + disk_size_gb                      = 1
      + id                                = (known after apply)
      + location                          = "westeurope"
      + logical_sector_size               = (known after apply)
      + max_shares                        = (known after apply)
      + name                              = "data-disk-1"
      + optimized_frequent_attach_enabled = false
      + performance_plus_enabled          = false
      + public_network_access_enabled     = true
      + resource_group_name               = "sb-west-europe"
      + source_uri                        = (known after apply)
      + storage_account_type              = "Standard_LRS"
      + tags                              = {
          + "Environment " = "Development"
        }
      + tier                              = (known after apply)
    }

  # azurerm_managed_disk.main[2] will be created
  + resource "azurerm_managed_disk" "main" {
      + create_option                     = "Empty"
      + disk_iops_read_only               = (known after apply)
      + disk_iops_read_write              = (known after apply)
      + disk_mbps_read_only               = (known after apply)
      + disk_mbps_read_write              = (known after apply)
      + disk_size_gb                      = 1
      + id                                = (known after apply)
      + location                          = "westeurope"
      + logical_sector_size               = (known after apply)
      + max_shares                        = (known after apply)
      + name                              = "data-disk-2"
      + optimized_frequent_attach_enabled = false
      + performance_plus_enabled          = false
      + public_network_access_enabled     = true
      + resource_group_name               = "sb-west-europe"
      + source_uri                        = (known after apply)
      + storage_account_type              = "Standard_LRS"
      + tags                              = {
          + "Environment " = "Development"
        }
      + tier                              = (known after apply)
    }

  # azurerm_network_interface.main[0] will be created
  + resource "azurerm_network_interface" "main" {
      + accelerated_networking_enabled = false
      + applied_dns_servers            = (known after apply)
      + id                             = (known after apply)
      + internal_domain_name_suffix    = (known after apply)
      + ip_forwarding_enabled          = false
      + location                       = "westeurope"
      + mac_address                    = (known after apply)
      + name                           = "sb--0-nic"
      + private_ip_address             = (known after apply)
      + private_ip_addresses           = (known after apply)
      + resource_group_name            = "sb-west-europe"
      + tags                           = {
          + "Environment " = "Development"
        }
      + virtual_machine_id             = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "internal"
          + primary                                            = true
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = (known after apply)
        }
    }

  # azurerm_network_interface.main[1] will be created
  + resource "azurerm_network_interface" "main" {
      + accelerated_networking_enabled = false
      + applied_dns_servers            = (known after apply)
      + id                             = (known after apply)
      + internal_domain_name_suffix    = (known after apply)
      + ip_forwarding_enabled          = false
      + location                       = "westeurope"
      + mac_address                    = (known after apply)
      + name                           = "sb--1-nic"
      + private_ip_address             = (known after apply)
      + private_ip_addresses           = (known after apply)
      + resource_group_name            = "sb-west-europe"
      + tags                           = {
          + "Environment " = "Development"
        }
      + virtual_machine_id             = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "internal"
          + primary                                            = true
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = (known after apply)
        }
    }

  # azurerm_network_interface.main[2] will be created
  + resource "azurerm_network_interface" "main" {
      + accelerated_networking_enabled = false
      + applied_dns_servers            = (known after apply)
      + id                             = (known after apply)
      + internal_domain_name_suffix    = (known after apply)
      + ip_forwarding_enabled          = false
      + location                       = "westeurope"
      + mac_address                    = (known after apply)
      + name                           = "sb--2-nic"
      + private_ip_address             = (known after apply)
      + private_ip_addresses           = (known after apply)
      + resource_group_name            = "sb-west-europe"
      + tags                           = {
          + "Environment " = "Development"
        }
      + virtual_machine_id             = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "internal"
          + primary                                            = true
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = (known after apply)
        }
    }

  # azurerm_network_interface_backend_address_pool_association.main[0] will be created
  + resource "azurerm_network_interface_backend_address_pool_association" "main" {
      + backend_address_pool_id = (known after apply)
      + id                      = (known after apply)
      + ip_configuration_name   = "internal"
      + network_interface_id    = (known after apply)
    }

  # azurerm_network_interface_backend_address_pool_association.main[1] will be created
  + resource "azurerm_network_interface_backend_address_pool_association" "main" {
      + backend_address_pool_id = (known after apply)
      + id                      = (known after apply)
      + ip_configuration_name   = "internal"
      + network_interface_id    = (known after apply)
    }

  # azurerm_network_interface_backend_address_pool_association.main[2] will be created
  + resource "azurerm_network_interface_backend_address_pool_association" "main" {
      + backend_address_pool_id = (known after apply)
      + id                      = (known after apply)
      + ip_configuration_name   = "internal"
      + network_interface_id    = (known after apply)
    }

  # azurerm_network_security_group.main will be created
  + resource "azurerm_network_security_group" "main" {
      + id                  = (known after apply)
      + location            = "westeurope"
      + name                = "sb--nsg"
      + resource_group_name = "sb-west-europe"
      + security_rule       = [
          + {
              + access                                     = "Allow"
              + destination_address_prefix                 = "*"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "80"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "Allow-HTTP-From-LB"
              + priority                                   = 2000
              + protocol                                   = "Tcp"
              + source_address_prefix                      = "AzureLoadBalancer"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
          + {
              + access                                     = "Allow"
              + destination_address_prefix                 = "VirtualNetwork"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "*"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "Allow-VNet-Inbound"
              + priority                                   = 1000
              + protocol                                   = "*"
              + source_address_prefix                      = "VirtualNetwork"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
          + {
              + access                                     = "Allow"
              + destination_address_prefix                 = "VirtualNetwork"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "*"
              + destination_port_ranges                    = []
              + direction                                  = "Outbound"
              + name                                       = "Allow-VNet-Outbound"
              + priority                                   = 1000
              + protocol                                   = "*"
              + source_address_prefix                      = "VirtualNetwork"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
          + {
              + access                                     = "Deny"
              + destination_address_prefix                 = "*"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "*"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "Deny-All-Inbound"
              + priority                                   = 4096
              + protocol                                   = "*"
              + source_address_prefix                      = "0.0.0.0/0"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
        ]
      + tags                = {
          + "Environment " = "Development"
        }
    }

  # azurerm_public_ip.main will be created
  + resource "azurerm_public_ip" "main" {
      + allocation_method       = "Static"
      + ddos_protection_mode    = "VirtualNetworkInherited"
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv4"
      + location                = "westeurope"
      + name                    = "lb-public-ip"
      + resource_group_name     = "sb-west-europe"
      + sku                     = "Standard"
      + sku_tier                = "Regional"
      + tags                    = {
          + "Environment " = "Development"
        }
    }

  # azurerm_subnet.main will be created
  + resource "azurerm_subnet" "main" {
      + address_prefixes                              = [
          + "10.0.2.0/24",
        ]
      + default_outbound_access_enabled               = true
      + id                                            = (known after apply)
      + name                                          = "internal"
      + private_endpoint_network_policies             = "Disabled"
      + private_link_service_network_policies_enabled = true
      + resource_group_name                           = "sb-west-europe"
      + virtual_network_name                          = "sb--network"
    }

  # azurerm_subnet_network_security_group_association.main will be created
  + resource "azurerm_subnet_network_security_group_association" "main" {
      + id                        = (known after apply)
      + network_security_group_id = (known after apply)
      + subnet_id                 = (known after apply)
    }

  # azurerm_virtual_machine_data_disk_attachment.main[0] will be created
  + resource "azurerm_virtual_machine_data_disk_attachment" "main" {
      + caching                   = "ReadWrite"
      + create_option             = "Attach"
      + id                        = (known after apply)
      + lun                       = 0
      + managed_disk_id           = (known after apply)
      + virtual_machine_id        = (known after apply)
      + write_accelerator_enabled = false
    }

  # azurerm_virtual_machine_data_disk_attachment.main[1] will be created
  + resource "azurerm_virtual_machine_data_disk_attachment" "main" {
      + caching                   = "ReadWrite"
      + create_option             = "Attach"
      + id                        = (known after apply)
      + lun                       = 10
      + managed_disk_id           = (known after apply)
      + virtual_machine_id        = (known after apply)
      + write_accelerator_enabled = false
    }

  # azurerm_virtual_machine_data_disk_attachment.main[2] will be created
  + resource "azurerm_virtual_machine_data_disk_attachment" "main" {
      + caching                   = "ReadWrite"
      + create_option             = "Attach"
      + id                        = (known after apply)
      + lun                       = 20
      + managed_disk_id           = (known after apply)
      + virtual_machine_id        = (known after apply)
      + write_accelerator_enabled = false
    }

  # azurerm_virtual_network.main will be created
  + resource "azurerm_virtual_network" "main" {
      + address_space                  = [
          + "10.0.0.0/16",
        ]
      + dns_servers                    = (known after apply)
      + guid                           = (known after apply)
      + id                             = (known after apply)
      + location                       = "westeurope"
      + name                           = "sb--network"
      + private_endpoint_vnet_policies = "Disabled"
      + resource_group_name            = "sb-west-europe"
      + subnet                         = (known after apply)
      + tags                           = {
          + "Environment " = "Development"
        }
    }

Plan: 25 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + lb_url = (known after apply)
```
