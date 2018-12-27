# Use Azure DNS for private domains

Read this first: [Use Azure DNS for private domains (Microsoft docs)](https://docs.microsoft.com/en-us/azure/dns/private-dns-overview)

Scenario (picture from Microsoft):

![scenario](https://github.com/www42/az-100/blob/master/Private-DNS-Zone/scenario.png?raw=true)

## Prerequisites: Create VNet, and VMs

Set variables (bash)

```bash
RGName="TestRG"
Location="westeurope"
VNetName="TestVNet3"
VM1Name="TestVM1"
VM2Name="TestVM2"
```

Create VNet

```bash
az network vnet create \
  --name $VNetName \
  --resource-group $RGName \
  --location $Location \
  --address-prefix 172.21.0.0/16 \
  --subnet-name backendSubnet \
  --subnet-prefix 172.21.128.0/25
```

```bash
az vm list --show-details -o table
```

Hier geht es weiter. Wie kann man eigentlich die Schriftgröße ändern?