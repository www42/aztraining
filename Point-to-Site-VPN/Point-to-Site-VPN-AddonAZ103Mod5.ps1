$Location = "westeurope"

$RG1 = "az1000401-RG"
$RG2 = "az1000402-RG"

$VNet1Name = "az1000401-vnet1"  # Hub
$VNet2Name = "az1000402-vnet2"  # Spoke

$VNet1 = Get-AzVirtualNetwork -Name $VNet1Name
$VNet2 = Get-AzVirtualNetwork -Name $VNet2Name

# Add Bastion Subnet to VNet1 ans VNet2

$BastionSubnetName = "AzureBastionSubnet"
$Bastion1SubnetPrefix = "10.104.255.0/27"
$Bastion2SubnetPrefix = "10.204.255.0/27"

Add-AzVirtualNetworkSubnetConfig -Name $BastionSubnetName `
                                 -VirtualNetwork $VNet1 `
                                 -AddressPrefix $Bastion1SubnetPrefix
$VNet1 | Set-AzVirtualNetwork
$VNet1 | % Subnets | ft Name,AddressPrefix,ProvisioningState

Add-AzVirtualNetworkSubnetConfig -Name $BastionSubnetName `
                                 -VirtualNetwork $VNet2 `
                                 -AddressPrefix $Bastion2SubnetPrefix
$VNet2 | Set-AzVirtualNetwork
$VNet2 | % Subnets | ft Name,AddressPrefix,ProvisioningState

# Create Public IP for Bastions
$Pip1 = New-AzPublicIpAddress -ResourceGroupName $RG1 `
                              -name "Bastion1-pip" `
                              -location $Location `
                              -AllocationMethod Static `
                              -Sku Standard

$Pip2 = New-AzPublicIpAddress -ResourceGroupName $RG2 `
                              -name "Bastion2-pip" `
                              -location $Location `
                              -AllocationMethod Static `
                              -Sku Standard

Get-AzPublicIpAddress | sort Name | ft Name,Location,PublicIpAllocationMethod,IpAddress

Get-AzPublicIpAddress -Name "Bastion1IP" | Remove-AzPublicIpAddress

# Create Bastions for VNet1 and VNet2
# https://docs.microsoft.com/de-de/azure/bastion/bastion-create-host-powershell

New-AzBastion -Name "VNet1-Bastion" `
              -ResourceGroupName $RG1 `
              -VirtualNetwork $VNet1 `
              -PublicIpAddress $Pip1
# Error reference id   subnet?
# Krrrr....



# ------------------------------
Hub_Group="az3000401-LabRG"
Hub_VNet="az3000401-vnet"
Spoke_Group="az3000402-LabRG"
Spoke_VNet="az3000402-vnet"
GatewayName="AdatumGateway"
GatewayPip="AdatumGateway-Pip"
GatewaySubnetPrefix="10.0.3.0/27"
GatewayClientAddressPrefix="192.168.0.0/24"
Location="westeurope"
