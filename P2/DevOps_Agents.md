# **Azure DevOps Agents and Their Role in Pipelines**

Azure DevOps provides a powerful **CI/CD (Continuous Integration and Continuous Deployment)** pipeline system that automates software development and deployment. A key component of this system is the **Agent**, which executes the jobs defined in a pipeline.



## **What is an Azure DevOps Agent?**
An **Azure DevOps Agent** is a computing resource that runs tasks assigned by an Azure Pipeline. It is responsible for performing operations like:
- Compiling code
- Running tests
- Packaging artifacts
- Deploying applications

### **Types of Agents**
Azure DevOps provides two types of agents:

### **1. Microsoft-Hosted Agents**
- **Managed by Azure** – No setup or maintenance required.
- **Ephemeral** – A new VM is provisioned for each job and discarded afterward.
- **Pre-installed with common tools** – Includes .NET, Node.js, Python, Java, etc.
- **Ideal for** quick, one-time builds and deployments.

### **2. Self-Hosted Agents**
- **Installed and managed by the user** on their infrastructure.
- **Persistent** – The same agent is reused for multiple jobs.
- **Supports custom dependencies** – You can install specific software, tools, or SDKs.
- **Ideal for** private networks, long-running processes, and cost optimization.



## **Agent Pools**
An **Agent Pool** is a collection of agents that can be shared across multiple projects and pipelines.

- **Microsoft-Hosted Pool** – Includes predefined VMs for different OS environments.
- **Self-Hosted Pool** – Allows organizations to manage their own agents.

> **Tip:** Use self-hosted agents if you need specific configurations or want to reduce build costs.


## **How Agents Work in Azure Pipelines**
1. **Pipeline Execution:** When a pipeline runs, it assigns jobs to available agents.
2. **Job Processing:** The agent downloads the pipeline definition and required files.
3. **Task Execution:** The agent runs tasks such as building code, running tests, and deploying applications.
4. **Reporting:** The agent sends job results back to Azure DevOps.



## **Example: Using an Agent in a YAML Pipeline**
Below is an example of a YAML pipeline that specifies an **Ubuntu-based Microsoft-hosted agent**:

```yaml
trigger:
  - main  # Runs when code is pushed to the main branch

pool:
  vmImage: 'ubuntu-latest'  # Uses a Microsoft-hosted agent

stages:
- stage: Build
  jobs:
  - job: BuildJob
    steps:
    - script: echo "Building the project..."
      displayName: 'Build Step'

    - task: PublishBuildArtifacts@1
      inputs:
        pathToPublish: '$(Build.ArtifactStagingDirectory)'
        artifactName: 'drop'
