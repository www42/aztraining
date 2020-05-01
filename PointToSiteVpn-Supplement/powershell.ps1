## Exercise 1: Define variables
$Location="westeurope"

$HubRg="az3000401-LabRG"
$HubVnet="az3000401-vnet"
$HubPeeringToSpoke="az3000401-vnet-to-az3000402-vnet"

$SpokeRg="az3000402-LabRG"
$SpokeVnet="az3000402-vnet"
$SpokePeeringToHub="az3000402-vnet-to-az3000401-vnet"

$GatewayName="AdatumGateway"
$GatewayPip="AdatumGateway-Pip"
$GatewaySubnetPrefix="10.0.3.0/27"
$GatewayAddressPool="192.168.0.0/24"

$RouteTable="az3000402-rt1"

$Vm1="az3000401-vm1"
$Vm2="az3000401-vm2"
$Vm3="az3000402-vm1"

az vm nic list --vm-name $Vm1 --resource-group $HubRg --query "[0].id" --output tsv

$Vm1Nic="az3000401-nic1"
$Vm2Nic="az3000401-nic2"
$Vm3Nic="az3000402-nic1"



#   # AZ-103
#   $Location="westeurope"
#   
#   $HubRg="az1000401-RG"
#   $HubVnet="az1000401-vnet1"
#   $HubPeeringToSpoke="az1000401-vnet1-to-az1000402-vnet2"
#   
#   $SpokeRg="az1000402-RG"
#   $SpokeVnet="az1000402-vnet2"
#   $SpokePeeringToHub="az1000402-vnet2-to-az1000401-vnet1"
#   
#   $GatewayName="AdatumGateway"
#   $GatewayPip="AdatumGateway-Pip"
#   $GatewaySubnetPrefix="10.104.3.0/27"
#   $GatewayAddressPool="192.168.0.0/24"
#   
#   $RouteTable="az1000402-rt1"
#   
#   # Vm1=""  # wird nicht benutzt
#   # Vm2=""  # wird nicht benutzt
#   # Vm3=""  # wird nicht benutzt
#   $Vm1Nic=""
#   $Vm2Nic=""
#   $Vm3Nic=""

## Exercise 2: Verify existing infrastructure
### Task 1: Verify hub and spoke virtual networks
az network vnet show `
    --name $HubVnet --resource-group $HubRg `
    --query '{name:name,location:location,addressSpace:addressSpace.addressPrefixes[0],provisioningState:provisioningState}' `
    --output table

az network vnet show `
    --name $SpokeVnet --resource-group $SpokeRg `
    --query '{name:name,location:location,addressSpace:addressSpace.addressPrefixes[0],provisioningState:provisioningState}' `
    --output table

### Task 2: Verify virtual machines
az vm list `
    --resource-group $HubRg --show-details `
    --query "[].{Name:name,State:powerState,privateIps:privateIps,Location:location,RG:resourceGroup,osType:storageProfile.osDisk.osType}" `
    --output table

az vm list `
    --resource-group $SpokeRg --show-details `
    --query "[].{Name:name,State:powerState,privateIps:privateIps,Location:location,RG:resourceGroup,osType:storageProfile.osDisk.osType}" `
    --output table

### Task 3: Verify peering
az network vnet peering show `
    --name $HubPeeringToSpoke --vnet-name $HubVnet --resource-group $HubRg `
    --query '{name:name,peeringState:peeringState,allowGatewayTransit:allowGatewayTransit,useRemoteGateways:useRemoteGateways}' `
    --output table

az network vnet peering show `
    --name $SpokePeeringToHub --vnet-name $SpokeVnet --resource-group $SpokeRg `
    --query '{name:name,peeringState:peeringState,allowGatewayTransit:allowGatewayTransit,useRemoteGateways:useRemoteGateways}' `
    --output table

### Task 4: Verify custom route
az network route-table show `
    --name $RouteTable --resource-group $SpokeRg `
    --query '{RouteTable:name,Route:routes[0].name,Prefix:routes[0].addressPrefix,NextHop:routes[0].nextHopIpAddress}' `
    --output table


## Exercise 3: Create virtual gateway
### Task 1: Create gateway subnet
az network vnet subnet create `
    --name GatewaySubnet --address-prefix $GatewaySubnetPrefix `
    --vnet-name $HubVnet --resource-group $HubRg

az network vnet subnet list `
    --vnet-name $HubVnet --resource-group $HubRg --output table

### Task 2: Create gateway public ip
az network public-ip create `
    --name $GatewayPip --resource-group $HubRg `
    --allocation-method dynamic --location $Location

az network public-ip list `
    --resource-group $HubRg `
    --query "[].{Name:name,Address:ipAddress,Method:publicIpAllocationMethod}" `
    --output table


### Task 3: Create gateway
az network vnet-gateway create `
    --name $GatewayName --vnet $HubVnet `
    --resource-group $HubRg --location $Location `
    --address-prefixes $GatewayAddressPool `
    --public-ip-addresses $GatewayPip `
    --vpn-type RouteBased --sku Basic `
    --no-wait

az network vnet-gateway list `
    --resource-group $HubRg `
    --query '[].{name:name,provisioningState:provisioningState,resourceGroup:resourceGroup,location:location,vpnType:vpnType}' `
    --output table


### Task 4: Configure *Allow gateway transit* on hub
az network vnet peering update `
    --name $HubPeeringToSpoke --vnet-name $HubVnet --resource-group $HubRg `
    --set allowGatewayTransit=true

az network vnet peering show `
    --name $HubPeeringToSpoke --vnet-name $HubVnet --resource-group $HubRg `
    --query '{name:name,peeringState:peeringState,allowGatewayTransit:allowGatewayTransit,useRemoteGateways:useRemoteGateways}' `
    --output table


# ---------------- hier --------------------------------------------
### Task 5: Configure *Use remote gateway* on spoke
az network vnet peering update `
    --name $SpokePeeringToHub --vnet-name $SpokeVnet --resource-group $SpokeRg `
    --set useRemoteGateways=true

az network vnet peering show `
    --name $SpokePeeringToHub --vnet-name $SpokeVnet --resource-group $SpokeRg `
    --query '{name:name,peeringState:peeringState,allowGatewayTransit:allowGatewayTransit,useRemoteGateways:useRemoteGateways}' `
    --output table


### Task 6: Configure *Virtual network gateway route propagation*
az network route-table update `
    --name $RouteTable --resource-group $SpokeRg `
    --set 'disableBgpRoutePropagation=false' 

az network route-table show `
    --name $RouteTable --resource-group $SpokeRg `
    --query '{name:name,disableBgpRoutePropagation:disableBgpRoutePropagation}' `
    --output table

### Task 7: Create root and client certificates
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
              
### Task 8: Copy root certificate to gateway configuration
[System.Convert]::ToBase64String($rootCert.RawData) | clip
              



## Exercise 4: Add VPN to PC and Test
### Task 1: Download and install VPN client on PC
### Task 2: Test VPN connection
Get-NetIPConfiguration | where InterfaceAlias -eq az3000401-vnet
Test-NetConnection 10.0.0.4 -Traceroute
Test-NetConnection 10.0.1.4 -Traceroute
Test-NetConnection 10.0.4.4 -Traceroute

### Task 3. Dissociate public IP addresses
az vm list-ip-addresses -o table

az network nic ip-config update --remove PublicIpAddress \
   --name ipconfig1 --nic-name $Vm1Nic --resource-group $HubRg

az network nic ip-config update --remove PublicIpAddress \
   --name ipconfig1 --nic-name $Vm2Nic --resource-group $HubRg

az network nic ip-config update --remove PublicIpAddress \
   --name ipconfig1 --nic-name $Vm3Nic --resource-group $SpokeRg

az vm list-ip-addresses -o table