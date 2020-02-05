$RG1 = "az1000401-RG"
$RG2 = "az1000402-RG"

$VNet1Name = "az1000401-vnet1"  # Hub
$VNet2Name = "az1000402-vnet2"  # Spoke

$Bastion1Subnet = "10.104.255.0/27"
$Bastion2Subnet = "10.204.255.0/27"





# Create Bastions for VNet1 and VNet2

$subnetName = "AzureBastionSubnet"
$subnet = New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 10.0.0.0/24
$vnet = New-AzVirtualNetwork -Name "myVnet" -ResourceGroupName " myBastionRG " -Location "westeurope" -AddressPrefix 10.0.0.0/16 -Subnet $subnet

Hub_Group="az3000401-LabRG"
Hub_VNet="az3000401-vnet"
Spoke_Group="az3000402-LabRG"
Spoke_VNet="az3000402-vnet"
GatewayName="AdatumGateway"
GatewayPip="AdatumGateway-Pip"
GatewaySubnetPrefix="10.0.3.0/27"
GatewayClientAddressPrefix="192.168.0.0/24"
Location="westeurope"

get-azvm