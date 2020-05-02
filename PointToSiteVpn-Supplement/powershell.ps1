## Exercise 1: Define variables
$Location="westeurope"

$HubRg="az3000401-LabRG"
$HubVnet="az3000401-vnet"
$HubPeeringToSpoke="az3000401-vnet-to-az3000402-vnet"

$SpokeRg="az3000402-LabRG"
$SpokeVnet="az3000402-vnet"
$SpokePeeringToHub="az3000402-vnet-to-az3000401-vnet"

$Vm1="az3000401-vm1"
$Vm2="az3000401-vm2"
$Vm3="az3000402-vm1"

$GatewayName="AdatumGateway"
$GatewayPip="AdatumGateway-Pip"
$GatewaySubnetPrefix="10.0.3.0/27"
$GatewayAddressPool="192.168.0.0/24"

$RouteTable="az3000402-rt1"

$RootCertificateName="AdatumRootCertificate"
$ClientCertificateName="AdatumClientCertificate"

$PcProcessorArchitecture="Amd64"




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
$RootCertificate = New-SelfSignedCertificate `
        -FriendlyName $RootCertificateName `
        -Subject "CN=$RootCertificateName" `
        -Type Custom `
        -KeySpec Signature `
        -KeyExportPolicy Exportable `
        -HashAlgorithm sha256 `
        -KeyLength 2048 `
        -KeyUsageProperty Sign `
        -KeyUsage CertSign `
        -CertStoreLocation 'Cert:\CurrentUser\My'

$ClientCertificate = New-SelfSignedCertificate `
        -FriendlyName $ClientCertificateName `
        -Subject "CN=$ClientCertificateName" `
        -Type Custom `
        -KeySpec Signature `
        -KeyExportPolicy Exportable `
        -HashAlgorithm sha256 `
        -KeyLength 2048 `
        -Signer $RootCertificate `
        -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2") `
        -CertStoreLocation 'Cert:\CurrentUser\My'

Get-ChildItem Cert:\CurrentUser\My | 
    where {$_.Subject -eq "CN=$RootCertificateName" -or $_.Subject -eq "CN=$ClientCertificateName"} | 
    ft Subject, Issuer, Thumbprint


### Task 8: Copy root certificate to gateway configuration
$RootCertPublicData=[System.Convert]::ToBase64String($RootCertificate.RawData)

az network vnet-gateway root-cert create `
    --name $RootCertificateName `
    --public-cert-data $RootCertPublicData `
    --gateway-name $GatewayName  --resource-group $HubRg

              



## Exercise 4: Add VPN to PC and Test
### Task 1: Download and install VPN client on PC
$Uri=az network vnet-gateway vpn-client generate `
    --processor-architecture $PcProcessorArchitecture `
    --name $GatewayName --resource-group $HubRg `
    --output tsv

$VpnZipPath="$env:HOMEPATH\Downloads"
Invoke-RestMethod -Uri $Uri -OutFile $VpnZipPath\VpnClient.zip
Expand-Archive -Path $VpnZipPath\VpnClient.zip -DestinationPath $VpnZipPath\VpnClient
& $VpnZipPath\VpnClient\WindowsAmd64\VpnClientSetupAmd64.exe
& cmd.exe /C "start ms-settings:network-vpn"


### Task 2: Test VPN connection
Get-NetIPConfiguration | where InterfaceAlias -eq $HubVnet
Test-NetConnection 10.0.0.4 -Traceroute
Test-NetConnection 10.0.1.4 -Traceroute
Test-NetConnection 10.0.4.4 -Traceroute

### Task 3. Dissociate public IP addresses
# VM --> NIC Id
$Vm1NicId=az vm nic list --vm-name $Vm1 --resource-group $HubRg --query "[0].id" --output tsv
$Vm2NicId=az vm nic list --vm-name $Vm2 --resource-group $HubRg --query "[0].id" --output tsv
$Vm3NicId=az vm nic list --vm-name $Vm3 --resource-group $SpokeRg --query "[0].id" --output tsv

# NIC Id --> IpConfig Id
$Vm1IpconfigId=az network nic show --ids $Vm1NicId --query "ipConfigurations[0].id" --output tsv
$Vm2IpconfigId=az network nic show --ids $Vm2NicId --query "ipConfigurations[0].id" --output tsv
$Vm3IpconfigId=az network nic show --ids $Vm3NicId --query "ipConfigurations[0].id" --output tsv

# IpConfig Id --> PublicIp Id
$Vm1PublicIpId=az network nic ip-config show --ids $Vm1IpconfigId --query "publicIpAddress.id" --output tsv
$Vm2PublicIpId=az network nic ip-config show --ids $Vm2IpconfigId --query "publicIpAddress.id" --output tsv
$Vm3PublicIpId=az network nic ip-config show --ids $Vm3IpconfigId --query "publicIpAddress.id" --output tsv

# Ipconfig ändern (public IP dissoziieren)
az network nic ip-config update --ids $Vm1IpconfigId --remove publicIpAddress
az network nic ip-config update --ids $Vm2IpconfigId --remove publicIpAddress
az network nic ip-config update --ids $Vm3IpconfigId --remove publicIpAddress

# Die public IPs sind nicht mehr mit den VMs assoziiert ...
az vm list-ip-addresses --output table

# ... aber als IP sind sie noch da
az network public-ip list --output table

# Public IP löschen
az network public-ip delete --ids $Vm1PublicIpId
az network public-ip delete --ids $Vm2PublicIpId
az network public-ip delete --ids $Vm3PublicIpId



## Exersise 5: Clean up
### Task 1: Remove Azure resources
### Task 2: Remove VPN aon PC
Remove-Item -Path $ClientCertificate.PSPath
Remove-Item -Path $RootCertificate.PSPath
Remove-Item -Path $VpnZipPath\VpnClient.zip
Remove-Item -Path $VpnZipPath\VpnClient -Recurse
