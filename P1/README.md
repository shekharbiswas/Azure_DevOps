# Azure: Deploying a scalable IaaS web server in Azure

### Introduction
Your company's development team has built an application that needs to be deployed on Azure. While the application itself is self-contained, the infrastructure must be customizable based on build-time specifications and scalable to support a CI/CD pipeline.

The application must run on Infrastructure as a Service (IaaS) instead of Azure App Service to reduce costs.
Since this is expected to be a high-traffic service, it should be deployed across multiple virtual machines (VMs) for scalability.
A load balancer should be used to distribute incoming traffic efficiently.
The infrastructure must follow security best practices to ensure a secure deployment.

#### Technology Stack
To meet these requirements, we will use:
✅ Packer → To create a custom server image for consistent VM deployments.
✅ Terraform → To define an automated, scalable, and repeatable infrastructure deployment.
✅ Azure Load Balancer → To manage and distribute incoming traffic across multiple VMs.
✅ Azure Policy → To enforce governance and security standards.

This approach will allow the infrastructure to be easily managed, cost-effective, and ready for future scalability as the application grows. 🚀


### Dependencies
To complete this project, you will need:

- An Azure account
- Packer installed
- Terraform installed

### Instructions

- Configure Azure Credentials

### Output
**Your words here**
