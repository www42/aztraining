# Lab: Windows-VM

## Lab Instructions

Start Cloud Shell (Bash)

```bash
az login
az account list --all -o table
```

Set Variables
```bash
Location="westeurope"
RGroup="AADConnect-RG"
```

Create Resource Group
```bash
az group create --name $RGroup --location $Location
az group list -o table
```

Create VNet with BationHost subnet
[Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/az.network/new-azbastion)

# PowerShell
Login-AzAccount
Get-AzContext
Select-AzSubscription -SubscriptionId "03da971b-2488-4613-b62b-c33d22247cbe"

$RGroup = "AADConnect-RG"
$Location = "westeurope"
$vnetName = "AADConnect-Vnet"
$vnetPrefix = "10.1.0.0/16"
$subnetName = "AzureBastionSubnet"
$subnetPrefix = "10.1.255.32/27"
$bastionName = "AADConnect-Bastion"
$bastionPipName = "AADConnect-Bastion-Pip"

$subnet = New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix $subnetPrefix
$vnet = New-AzVirtualNetwork -Name $vnetName -ResourceGroupName $RGroup -Location $Location -AddressPrefix $vnetPrefix -Subnet $subnet
$publicip = New-AzPublicIpAddress -ResourceGroupName $RGroup -name $bastionPipName -location $Location -AllocationMethod Static -Sku Standard
$bastion = New-AzBastion -ResourceGroupName $RGroup -Name $bastionName -PublicIpAddress $publicip -VirtualNetwork $vnet
```

List most popular Marketplace VM images
```bash
az vm image list -o table
```

List Windows Server Marketplace images
```bash
az vm image list-publishers --location $Location --query "[?contains(name,'Microsoft')]" -o table

#  publisher --> MicrosoftWindowsServer

az vm image list-offers --publisher MicrosoftWindowsServer --location $Location -o table
#  offer --> WindowsServer

az vm image list-skus --publisher MicrosoftWindowsServer --offer WindowsServer --location $Location -o table
#  sku --> 2019-Datacenter

az vm image list --publisher MicrosoftWindowsServer --offer WindowsServer --sku 2019-Datacenter --all --location $Location --query '[].{publisher:publisher,offer:offer,sku:sku,version:version}' -o table
#  version --> latest

VM_Image="MicrosoftWindowsServer:WindowsServer:2019-Datacenter:latest"
az vm image show --urn $VM_Image --location $Location
```