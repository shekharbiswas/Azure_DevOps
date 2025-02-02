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

### Create Server Image: Packer Template

First, use Packer to create a server image, ensuring the provided application is included in the template. 

Define the necessary variables and configure the provisioning steps to install the application within the image. 
Be sure to set up any required configuration files, environment variables, and dependencies during the provisioning process.

Once the template is ready, run Packer to build the image. Validate the image to ensure everything is correctly configured. After that, use the newly created image to deploy servers with the application pre-installed, ensuring consistency across environments.

