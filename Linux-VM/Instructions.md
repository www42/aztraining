# Lab: Linux-VM

This Lab is from
[Microsoft Docs](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-cli).

## Scenario
* List available Linux VM images from Azure Marketplace. 
* Create VM. 
* Connect to VM via SSH. 
* Install Web server nginx.



## Links

* [Linux VM images in Azure Marketplace](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/cli-ps-findimage)

## Lab Instructions

### Start Cloud Shell (Bash)
```bash
az account list -o table
```

### Set Variables
```bash
Location="westeurope"
RGroup="SinsheimRG"
VM_Name="Web3"
VM_AdminName="paul"
VM_Image="Canonical:UbuntuServer:18.04-LTS:latest"
```

### Create Resource Group
```bash
az group create --name $RGroup --location $Location

az group list -o table
```

### List most popular Marketplace images

Syntax: [List the VM/VMSS images available in the Azure Marketplace](https://docs.microsoft.com/en-us/cli/azure/vm/image?view=azure-cli-latest#az-vm-image-list)

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

VM_Image="Canonical:UbuntuServer:18.04-LTS:latest"
az vm image show --urn $VM_Image --location $Location
```


### No SSH keys available
```bash
ls -l ~/.ssh
```

### Create VM

Syntax: [Create an Azure Virtual Machine](https://docs.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest#az-vm-create)

```bash
az vm create --name $VM_Name --image $VM_Image --admin-username $VM_AdminName --resource-group $RGroup --generate-ssh-keys
az vm list --resource-group $RGroup \
           --query "[].{\
                        name:name,\
                        location:location,\
                        resourceGroup:storageProfile.osDisk.managedDisk.resourceGroup,\
                        osType:storageProfile.osDisk.osType,\
                        size:hardwareProfile.vmSize,\
                        provisioningState:provisioningState\
                       }"\
           -o table

az vm show --name $VM_Name --resource-group $RGroup --show-details -o table
az vm show --name $VM_Name --resource-group $RGroup --show-details \
           --query "{name:name,\
                     location:location,\
                     powerState:powerState,\
                     publicIps:publicIps,\
                     privateIps:privateIps,\
                     adminUsername:osProfile.adminUsername\
                    }"\
           -o table
```

### Note the public IP address
```bash
VM_PublicIp=$(az vm show --name $VM_Name --resource-group $RGroup --show-details \
                         --query "[publicIps]"\
                         -o tsv)

echo $VM_PublicIp
```

### Inspect SSH keys
```bash
ls -l ~/.ssh
cat ~/.ssh/id_rsa.pub
```

### Inspect the NSG

Syntax: [List network security groups](https://docs.microsoft.com/de-de/cli/azure/network/nsg?view=azure-cli-latest#az-network-nsg-list)
```bash
az network nsg list --resource-group $RGroup -o table
```

### Open port 80 for web traffic
Syntax: [Open a VM to inbound traffic on specified ports](https://docs.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest#az-vm-open-port)
```bash
az vm open-port --name $VM_Name --port 80 --resource-group $RGroup
```
