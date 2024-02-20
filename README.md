# udacity-azure-devops
## Introduction
In this project, we'll learn how to use Packer to build image and use Terraform to provision Azure resources
## Getting Started
Before you start the project make sure you clone the starter code at this [repo](https://github.com/udacity/nd082-Azure-Cloud-DevOps-Starter-Code/tree/06984450f0963cb8204811a51100db091dcefebe/C1%20-%20Azure%20Infrastructure%20Operations/project/starter_files)
## Dependencies
1. Create an Azure account
2. Install Azure command line interface
3. Install Packer
4. Install Terraform

## Instructions
Diving into the project here is how you can use Packer and Terraform.
- Packer:
1. ```az login``` to login to your Azure account and get credential
2. ```az ad sp create-for-rbac --role Contributor --scopes /subscriptions/your-subcription-id --query "{ client_id: appId, client_secret: password }"``` to create Role for Packer
3. Paste your previous step's output to create environment variables
```
    New-Item -Path Env:\ARM_CLIENT_ID -Value 'client-id'
    New-Item -Path Env:\ARM_CLIENT_SECRET -Value 'client-secret'
    New-Item -Path Env:\ARM_SUBSCRIPTION_ID -Value 'subcription-id'
```
4. Edit [server.json](server.json) file.
5. Run ```packer build .\server.json``` in the terminal to build the image you config in [server.json](server.json)
- Terraform:
1. Please follow [this](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli)tutorial to store remote state in Azure Storage Account and get temporary credential
2. You need to import resource group first ```terraform import azurerm_resource_group.demorg /subscriptions/<resource-group-id>/resourceGroups/<resource-group-name>``` inorder to use the resource group you created from previous step
3. You can custom the resource just by changing the variable in ```variables.tf``` file 
4. Running ```terraform init``` to init the module then ```terraform plan -out solution.plan``` to preview the change Terraform will make
5. Running ```terraform apply``` to apply the plan

Output
- The image we created by Packer
- The infrastructure provisioned by Terraform