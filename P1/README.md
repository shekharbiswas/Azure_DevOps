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
- run: **packer build demo.json**



**After successful build, check the image:**
![image](https://github.com/user-attachments/assets/ae19cbf6-1318-4387-8247-a0b0825b50bb)



### Terraform 


The terraform file creates these resources listed below

### Resources

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






