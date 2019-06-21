# Lab: VM-Windows

## Scenario

List available Linux VM images from Azure Marketplace. Create VM. Connect to VM via SSH. Install Web server nginx.

## This Lab is stolen from

[Quickstart: Create a Linux virtual machine with the Azure CLI](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-cli)

## Lego building blocks

* [Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/)

## Lab Instructions

### Start Cloud Shell (Bash)

```bash
az account list -o table
```

### Set Variables

### Create Resource Group

```bash
az group create --name $RGroup --location $Location

az group list -o table
```

### List most popular Marketplace images

```bash
az vm image list -o table
```

### List Linux Marketplace images

```bash
az vm image list-publishers --location $Location -o table
#  publisher --> Canonical

az vm image list-offers --publisher Canonical --location $Location -o table
#  offer --> UbuntuServer

az vm image list-skus --publisher Canonical --offer UbuntuServer --location $Location -o table
#  sku --> 18.04-LTS

az vm image list --publisher Canonical --offer UbuntuServer --sku 18.04-LTS --all --location $Location -o table
#  version --> latest

MyLinuxImage="Canonical:UbuntuServer:18.04-LTS:latest"
az vm image show --urn $MyLinuxImage --location $Location
```

### List Windows Server Marketplace images

```bash
az vm image list-publishers --location $Location --query "[?contains(name,'Microsoft')]" -o table
#  publisher --> MicrosoftWindowsServer

az vm image list-offers --publisher MicrosoftWindowsServer --location $Location -o table
#  offer --> WindowsServer

az vm image list-skus --publisher MicrosoftWindowsServer --offer WindowsServer --location $Location -o table
#  sku --> 2019-Datacenter

az vm image list --publisher MicrosoftWindowsServer --offer WindowsServer --sku 2019-Datacenter --all --location $Location --query '[].{publisher:publisher,offer:offer,sku:sku,version:version}' -o table
#  version --> latest

MyWindowsImage="MicrosoftWindowsServer:WindowsServer:2019-Datacenter:latest"
az vm image show --urn $MyWindowsImage --location $Location
```
