# Lab: Point-to-Site VPN 
# (Addon to AZ-300T02 Mod 03 Lab)

## Lab Instructions

### Start Cloud Shell (Bash)

```bash
az version
```

### Variables:

```bash
Hub_Group="az3000401-LabRG"
Hub_VNet="az3000401-vnet"
Spoke_Group="az3000402-LabRG"
Spoke_VNet="az3000402-vnet"
GatewayName="AdatumGateway"
GatewayPip="AdatumGateway-Pip"
GatewaySubnetPrefix="10.0.3.0/27"
GatewayClientAddressPrefix="192.168.0.0/24"
Location="westeurope"
Peering_1to2_Name="az3000401-vnet-to-az3000402-vnet"
Peering_2to1_Name="az3000402-vnet-to-az3000401-vnet"
RouteTableName="az3000402-rt1"
Vm1="az3000401-vm1"
Vm2="az3000401-vm2"
Vm3="az3000402-vm1"
Vm1NicName="az3000401-nic1"
Vm2NicName="az3000401-nic2"
Vm3NicName="az3000402-nic1"
Vm1Pip="az3000401-pip1"
Vm2Pip="az3000401-pip2"
Vm3Pip="az3000402-pip1"
```

## Exercise 1: Create Virtual Gateway in the Hub VNet
Tasks

0. Verify hub and spoke
1. Create gateway subnet
2. Create gateway public ip
3. Create gateway
4. Configure *Allow gateway transit* on hub
5. Configure *Use remote gateway* on spoke
6. Configure *Virtual network gateway route propagation*


### Task 0. Verify hub and spoke
```bash
az network vnet show --name $Hub_VNet --resource-group $Hub_Group \
        --query '{name:name,location:location,provisioningState:provisioningState,addressSpace:addressSpace.addressPrefixes[0]}' -o table

az network vnet show --name $Spoke_VNet --resource-group $Spoke_Group \
        --query '{name:name,location:location,provisioningState:provisioningState,addressSpace:addressSpace.addressPrefixes[0]}' -o table
```

### Task 1. Create gateway subnet
```bash
az network vnet subnet create --name GatewaySubnet \
                              --address-prefix $GatewaySubnetPrefix \
                              --vnet-name $Hub_VNet \
                              --resource-group $Hub_Group

az network vnet subnet list --vnet-name $Hub_VNet --resource-group $Hub_Group -o table
```

### Task 2. Create gateway public ip
```bash
az network public-ip create --name $GatewayPip \
                            --resource-group $Hub_Group \
                            --allocation-method dynamic \
                            --location $Location

az network public-ip list -o table --resource-group $Hub_Group
```

### Task 3. Create gateway
```bash
az network vnet-gateway create --name $GatewayName \
                               --location $Location \
                               --resource-group $Hub_Group \
                               --vnet $Hub_VNet \
                               --address-prefixes $GatewayClientAddressPrefix \
                               --public-ip-addresses $GatewayPip \
                               --vpn-type RouteBased \
                               --sku Basic \
                               --no-wait

az network vnet-gateway list --resource-group $Hub_Group \
    --query '[].{name:name,provisioningState:provisioningState,resourceGroup:resourceGroup,location:location,vpnType:vpnType}' \
    -o table
```

### Task 4. Configure "Allow gateway transit" on hub
[Microsoft Docs](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-peering-gateway-transit)
```bash
az network vnet peering update --name $Peering_1to2_Name --vnet-name $Hub_VNet --resource-group $Hub_Group --set allowGatewayTransit=true

az network vnet peering show --name $Peering_1to2_Name --vnet-name $Hub_VNet --resource-group $Hub_Group \
    --query '{name:name,peeringState:peeringState,allowGatewayTransit:allowGatewayTransit,useRemoteGateways:useRemoteGateways}' \
    -o table
```

### Task 5. Configure "Use remote gateway" on spoke
```bash
az network vnet peering update --name $Peering_2to1_Name --vnet-name $Spoke_VNet --resource-group $Spoke_Group --set useRemoteGateways=true

az network vnet peering show --name $Peering_2to1_Name --vnet-name $Spoke_VNet --resource-group $Spoke_Group \
    --query '{name:name,peeringState:peeringState,allowGatewayTransit:allowGatewayTransit,useRemoteGateways:useRemoteGateways}' \
    -o table
```


### Task 6. Configure *Virtual network gateway route propagation*
Warum? Damit man von von VM3 aus Windows10 anpingen kann (ping 192.168.0.2)

[Microsoft Docs](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview#custom-routes)
```bash
az network route-table update \
    --name $RouteTableName \
    --resource-group $Spoke_Group \
    --set 'disableBgpRoutePropagation=false' 

az network route-table show --name $RouteTableName --resource-group $Spoke_Group \
    --query '{name:name,disableBgpRoutePropagation:disableBgpRoutePropagation}' \
    -o table
```


## Exercise 2: Create Point-to-Site Connection
Tasks

1. Create root and client certificates
2. Copy root certificate to gateway configuration
3. Download and install VPN Client (Windows)
4. Test VPN connection
5. Remove public IP addresses

### Task 1. Create root and client certificates
On Windows 10 open PowerShell. Create a root certificate
```bash
$rootCert = New-SelfSignedCertificate `
              -Type Custom `
              -KeySpec Signature `
              -Subject 'CN=AdatumRootCertificate' `
              -KeyExportPolicy Exportable `
              -HashAlgorithm sha256 `
              -KeyLength 2048 `
              -CertStoreLocation 'Cert:\CurrentUser\My' `
              -KeyUsageProperty Sign `
              -KeyUsage CertSign `
              -FriendlyName 'AdatumRootCertificate'
```

Copy root certificate (public part) into clipboard
```bash
[System.Convert]::ToBase64String($rootCert.RawData) | clip
```

Create client certificate signed by the root certificate
```bash
$clientCert = New-SelfSignedCertificate `
                -Type Custom `
                -KeySpec Signature `
                -Subject 'CN=AdatumClientCertificate' `
                -KeyExportPolicy Exportable `
                -HashAlgorithm sha256 `
                -KeyLength 2048 `
                -CertStoreLocation 'Cert:\CurrentUser\My' `
                -Signer $rootCert `
                -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2") `
                -FriendlyName 'AdatumClientCertificate'
```

List certificates. Keep PowerShell open.
```bash
Get-ChildItem Cert:\CurrentUser\My
```

### Task 2. Copy root certificate to gateway configuration
Paste clipboard into browser (Azure Portal) "Public certificate data"

![Azure Portal](img/RootCert-AzureGW.png)


### Task 3. Download and install VPN Client (Windows 10)
Portal download

Windows 10
![Azure Portal](img/VPN-Client.PNG)

### Task 4. Test VPN connection
Windows 10 PowerShell
```bash
Get-NetIPConfiguration | where InterfaceAlias -eq az3000401-vnet
Test-NetConnection 10.0.0.4 -Traceroute
Test-NetConnection 10.0.1.4 -Traceroute
Test-NetConnection 10.0.4.4 -Traceroute
```

### Task 5. Dissociate public IP addresses

Public IP addresses of VMs are not needed any more.
```bash
az vm list-ip-addresses -o table

az network nic ip-config update --remove PublicIpAddress \
   --name ipconfig1 --nic-name $Vm1NicName --resource-group $Hub_Group

az network nic ip-config update --remove PublicIpAddress \
   --name ipconfig1 --nic-name $Vm2NicName --resource-group $Hub_Group

az network nic ip-config update --remove PublicIpAddress \
   --name ipconfig1 --nic-name $Vm3NicName --resource-group $Spoke_Group

az vm list-ip-addresses -o table
```