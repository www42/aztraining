# Lab: VM-Windows10

## Scenario

Create VM Windows 10.

## Lab Instructions

### Start Cloud Shell (Bash)

```bash
az account list -o table
```

### Set Variables

Location="westeurope"
RGroup="AdOnPremRG"

### List Resource Group

```bash
az group show --name $RGroup
```

### List most popular Marketplace images

```bash
az vm image list -o table
```

### List Windows 10 Marketplace images

```bash
az vm image list-publishers --location $Location --query "[?contains(name,'Microsoft')]" -o table
#  publisher --> MicrosoftWindowsDesktop

az vm image list-offers --publisher MicrosoftWindowsDesktop --location $Location -o table
#  offer --> Windows-10

az vm image list-skus --publisher MicrosoftWindowsDesktop --offer Windows-10 --location $Location -o table
#  sku --> rs4-pro

az vm image list --publisher MicrosoftWindowsDesktop --offer Windows-10 --sku rs4-pro --all --location $Location -o table
#  version --> latest

MyImage="MicrosoftWindowsDesktop:Windows-10:rs4-pro:latest"
az vm image show --urn $MyImage --location $Location
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
